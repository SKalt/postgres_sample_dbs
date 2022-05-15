--
-- PostgreSQL database dump
--

-- Dumped from database version 14.0
-- Dumped by pg_dump version 14.0

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: assert_assumptions_ok(date, date); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.assert_assumptions_ok(IN start_survey_date date, IN end_survey_date date)
    LANGUAGE plpgsql
    AS $_$
declare
  -- Each survey date (i.e. "time_value") has exactly the same number of states (i.e. "geo_value").
  -- Each state has the same number, of survey date values.

  expected_states constant text[] not null := array[
    'ak', 'al', 'ar', 'az', 'ca', 'co', 'ct', 'dc', 'de', 'fl', 'ga',
    'hi', 'ia', 'id', 'il', 'in', 'ks', 'ky', 'la', 'ma', 'md',
    'me', 'mi', 'mn', 'mo', 'ms', 'mt', 'nc', 'nd', 'ne', 'nh',
    'nj', 'nm', 'nv', 'ny', 'oh', 'ok', 'or', 'pa', 'ri', 'sc',
    'sd', 'tn', 'tx', 'ut', 'va', 'vt', 'wa', 'wi', 'wv', 'wy'
  ];

  expected_state_count constant int := cardinality(expected_states);

  actual_states_qry constant text not null :=
    'select array_agg(distinct geo_value order by geo_value) from ?';

  actual_states text[] not null := '{}';

  expected_dates date[] not null := array[start_survey_date];

  actual_dates_qry constant text not null :=
    'select array_agg(distinct time_value order by time_value) from ?';

  actual_dates date[] not null := '{}';

  expected_date_count int not null := 0;

  names constant covidcast_names[] not null := (
    select array_agg((csv_file, staging_table, signal)::covidcast_names) from covidcast_names);

  expected_total_count int not null := 0;

  r covidcast_names not null := ('', '', '');
  d  date     not null := start_survey_date;
  t  text     not null := '';
  n  int      not null := 0;
  b  boolean  not null := false;
begin
  loop
    d := d + interval '1 day';
    expected_dates := expected_dates||d;
    exit when d >= end_survey_date;
  end loop;
  expected_date_count := cardinality(expected_dates);
  expected_total_count := expected_state_count*expected_date_count;

  foreach r in array names loop

    -- signal: One of covidcast_names.signal.
    execute replace('select distinct signal from ?', '?', r.staging_table) into t;
    assert t = r.signal, 'signal from '||r.staging_table||' <> "'||r.signal||'"';

    -- geo_type: state.
    execute 'select distinct geo_type from '||r.staging_table into t;
    assert t = 'state', 'geo_type from '||r.staging_table||' <> "state"';

    -- data_source: fb-survey.
    execute 'select distinct data_source from '||r.staging_table into t;
    assert t = 'fb-survey', 'data_source from '||r.staging_table||' <> "fb-survey"';

    -- direction: IS NULL.
    execute $$select distinct coalesce(direction, '<null>') from $$||r.staging_table into t;
    assert t = '<null>', 'direction from '||r.staging_table||' <> "<null>"';

    -- Expected total count(*).
    execute 'select count(*) from '||r.staging_table into n;
    assert n = expected_total_count, 'count from '||r.staging_table||' <> expected_total_count';

    -- geo_value: Check list of actual distinct states is as expected.
    execute replace(actual_states_qry, '?', r.staging_table) into actual_states;
    assert actual_states = expected_states, 'actual_states <> expected_states';

    -- geo_value: Expected distinct state (i.e. "geo_value") count(*).
    execute 'select count(distinct geo_value) from '||r.staging_table into n;
    assert n = expected_state_count, 'distinct state count per survey date from '||r.staging_table||' <> expected_state_count';

    -- time_value: Check list of actual distinct survey dates is as expected.
    execute replace(actual_dates_qry, '?', r.staging_table) into actual_dates;
    assert actual_dates = expected_dates, 'actual_dates <> expected_dates';

    -- time_value: Expected distinct survey date (i.e. "time_value") count(*).
    execute 'select count(distinct time_value) from '||r.staging_table into n;
    assert n = expected_date_count, 'distinct survey date count per state from '||r.staging_table||' <> expected_date_count';

    -- Same number of states (i.e. "geo_value") for each distinct survey date (i.e. "time_value").
    execute '
      with r as (
        select time_value, count(time_value) as n from '||r.staging_table||'
        group by time_value)
      select distinct n from r' into n;
    assert n = expected_state_count, 'distinct state count from '||r.staging_table||' <> expected_state_count';

    -- Same number of survey dates (i.e. "time_value") for each distinct state (i.e. geo_value).
    execute '
      with r as (
        select geo_value, count(geo_value) as n from '||r.staging_table||'
        group by geo_value)
      select distinct n from r' into n;
    assert n = expected_date_count, 'distinct state count from '||r.staging_table||' <> expected_date_count';

    -- value: check is legal percentage value.
    execute '
      select
        max(value) between 0 and 100 and
        min(value) between 0 and 100
      from '||r.staging_table into b;
    assert b, 'max(value), min(value) from '||r.staging_table||' both < 100 FALSE';
  end loop;

  -- code and geo_value: check same exact one-to-one correspondence in all staging tables.
  declare
    chk_code_and_geo_values constant text := $$
    with
      a1 as (
        select to_char(code, '90')||' '||geo_value as v from ?1),
      v1 as (
        select v, count(v) as n from a1 group by v),
      a2 as (
        select to_char(code, '90')||' '||geo_value as v from ?2),
      v2 as (
        select v, count(v) as n from a2 group by v),
      a3 as (
        select to_char(code, '90')||' '||geo_value as v from ?3),
      v3 as (
        select v, count(v) as n from a3 group by v),

      v4 as (select v, n from v1 except select v, n from v2),
      v5 as (select v, n from v2 except select v, n from v1),
      v6 as (select v, n from v1 except select v, n from v3),
      v7 as (select v, n from v3 except select v, n from v1),

      r as (
        select v, n from v4
        union all
        select v, n from v5
        union all
        select v, n from v6
        union all
        select v, n from v6)

    select count(*) from r$$;
  begin
    execute replace(replace(replace(chk_code_and_geo_values, 
    '?1', names[1].staging_table),
    '?2', names[2].staging_table),
    '?3', names[3].staging_table
    ) into n;

    assert n = 0, '(code, geo_value) tuples from the three staging tables disagree';
  end;

  -- Check set of (geo_value, time_value) values same in each staging table.
  declare
    chk_putative_pks constant text := '
      with
        v1 as (
          select geo_value, time_value from ?1
          except
          select geo_value, time_value from ?2),

        v2 as (
          select geo_value, time_value from ?2
          except
          select geo_value, time_value from ?1),

        v3 as (
          select geo_value, time_value from ?1
          except
          select geo_value, time_value from ?3),

        v4 as (
          select geo_value, time_value from ?3
          except
          select geo_value, time_value from ?1),

        v5 as (
          select geo_value, time_value from v1
          union all
          select geo_value, time_value from v2
          union all
          select geo_value, time_value from v3
          union all
          select geo_value, time_value from v4)

      select count(*) from v5';
  begin
    execute replace(replace(replace(chk_putative_pks,
        '?1', names[1].staging_table),
        '?2', names[2].staging_table),
        '?3', names[3].staging_table)
      into n;

    assert n = 0, 'pk values from ' ||
      replace(replace(replace('?1, ?2, ?3',
        '?1', names[1].staging_table),
        '?2', names[2].staging_table),
        '?3', names[3].staging_table) ||
      ' do not line up';
  end;
end;
$_$;


ALTER PROCEDURE public.assert_assumptions_ok(IN start_survey_date date, IN end_survey_date date) OWNER TO postgres;

--
-- Name: cr_copy_from_scripts(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.cr_copy_from_scripts(which integer) RETURNS text
    LANGUAGE plpgsql
    AS $_$
<<b>>declare
  copy_from_csv constant text :=
    $$\copy ?1 from '?2' with (format 'csv', header true);$$;

  csv_file       text not null := '';
  staging_table  text not null := '';
begin
  with a as (
    select
      row_number() over (order by s.csv_file) as r,
      s.csv_file,
      s.staging_table
    from covidcast_names as s)
  select a.csv_file, a.staging_table
  into b.csv_file, b.staging_table
  from a where a.r = which;

  return replace(replace(
    copy_from_csv,
    '?1',
    staging_table),
    '?2',
    csv_file);
end b;
$_$;


ALTER FUNCTION public.cr_copy_from_scripts(which integer) OWNER TO postgres;

--
-- Name: cr_staging_tables(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.cr_staging_tables()
    LANGUAGE plpgsql
    AS $$
declare
  drop_table constant text := '
    drop table if exists ? cascade;                               ';

  create_staging_table constant text := '
    create table ?(
      code         int     not null,
      geo_value    text    not null,
      signal       text    not null,
      time_value   date    not null,
      direction    text,
      issue        date    not null,
      lag          int     not null,
      value        numeric not null,
      stderr       numeric not null,
      sample_size  numeric not null,
      geo_type     text    not null,
      data_source  text    not null,
      constraint ?_pk primary key(geo_value, time_value));
    ';

  names constant text[] not null := (
    select array_agg(staging_table) from covidcast_names);
  name text not null := '';
begin
  foreach name in array names loop
    execute replace(drop_table, '?',name);

    execute replace(create_staging_table, '?',name);
  end loop;
end;
$$;


ALTER PROCEDURE public.cr_staging_tables() OWNER TO postgres;

--
-- Name: populate_t(integer, double precision, double precision, double precision, double precision); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.populate_t(IN no_of_rows integer, IN slope double precision, IN intercept double precision, IN mean double precision, IN stddev double precision)
    LANGUAGE plpgsql
    AS $$
begin
  delete from t;

  with
    a1 as (
      select
        s.v        as k,
        s.v        as x,
        (s.v * slope) + intercept as y
      from generate_series(1, no_of_rows) as s(v)),

    a2 as (
      select (
        row_number() over()) as k,
        r.v as delta
      from normal_rand(no_of_rows, mean, stddev) as r(v))

  insert into t(k, x, y, delta)
  select
    k, x, a1.y, a2.delta
  from a1 inner join a2 using(k);

  insert into t(k, x, y, delta) values
    (no_of_rows + 1,    0, null, null),
    (no_of_rows + 2, null,    0, null);
end;
$$;


ALTER PROCEDURE public.populate_t(IN no_of_rows integer, IN slope double precision, IN intercept double precision, IN mean double precision, IN stddev double precision) OWNER TO postgres;

--
-- Name: xform_to_covidcast_fb_survey_results(); Type: PROCEDURE; Schema: public; Owner: postgres
--

CREATE PROCEDURE public.xform_to_covidcast_fb_survey_results()
    LANGUAGE plpgsql
    AS $$
declare
  -- Check that the staging tables have the expected names for their roles.
  -- Each subquery assignemnt will fail if doesn't return exactly one row.
  mask_wearers_name    text not null := (select staging_table from covidcast_names where staging_table = 'mask_wearers');
  symptoms_name        text not null := (select staging_table from covidcast_names where staging_table = 'symptoms');
  cmnty_symptoms_name  text not null := (select staging_table from covidcast_names where staging_table = 'cmnty_symptoms');

  stmt text not null := '
    insert into covidcast_fb_survey_results(
      survey_date, state,
      mask_wearing_pct,    mask_wearing_stderr,    mask_wearing_sample_size,
      symptoms_pct,        symptoms_stderr,        symptoms_sample_size,
      cmnty_symptoms_pct,  cmnty_symptoms_stderr,  cmnty_symptoms_sample_size)
    select
      time_value, geo_value,
      m.value, m.stderr, round(m.sample_size),
      s.value, s.stderr, round(s.sample_size),
      c.value, c.stderr, round(c.sample_size)
    from
      ?1 as m
      inner join ?2 as s using (time_value, geo_value)
      inner join ?3 as c using (time_value, geo_value)';

begin
  drop table if exists covidcast_fb_survey_results cascade;

  create table covidcast_fb_survey_results(
    survey_date                 date     not null,
    state                       text     not null,
    mask_wearing_pct            numeric  not null,
    mask_wearing_stderr         numeric  not null,
    mask_wearing_sample_size    int      not null,
    symptoms_pct                numeric  not null,
    symptoms_stderr             numeric  not null,
    symptoms_sample_size        int      not null,
    cmnty_symptoms_pct          numeric  not null,
    cmnty_symptoms_stderr       numeric  not null,
    cmnty_symptoms_sample_size  int      not null,

    constraint covidcast_fb_survey_results_pk primary key (state, survey_date),

    constraint covidcast_fb_survey_results_chk_mask_wearing_pct    check(mask_wearing_pct   between 0 and 100),
    constraint covidcast_fb_survey_results_chk_symptoms_pct        check(symptoms_pct       between 0 and 100),
    constraint covidcast_fb_survey_results_chk_cmnty_symptoms_pct  check(cmnty_symptoms_pct between 0 and 100),

    constraint covidcast_fb_survey_results_chk_mask_wearing_stderr    check(mask_wearing_stderr   > 0),
    constraint covidcast_fb_survey_results_chk_symptoms_stderr        check(symptoms_stderr       > 0),
    constraint covidcast_fb_survey_results_chk_cmnty_symptoms_stderr  check(cmnty_symptoms_stderr > 0),

    constraint covidcast_fb_survey_results_chk_mask_wearing_sample_size    check(mask_wearing_sample_size   > 0),
    constraint covidcast_fb_survey_results_chk_symptoms_sample_size        check(symptoms_sample_size       > 0),
    constraint covidcast_fb_survey_results_chk_cmnty_symptoms_sample_size  check(cmnty_symptoms_sample_size > 0)
  );

  execute replace(replace(replace(stmt,
    '?1', mask_wearers_name),
    '?2', symptoms_name),
    '?3', cmnty_symptoms_name);
end;
$$;


ALTER PROCEDURE public.xform_to_covidcast_fb_survey_results() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: cmnty_symptoms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cmnty_symptoms (
    code integer NOT NULL,
    geo_value text NOT NULL,
    signal text NOT NULL,
    time_value date NOT NULL,
    direction text,
    issue date NOT NULL,
    lag integer NOT NULL,
    value numeric NOT NULL,
    stderr numeric NOT NULL,
    sample_size numeric NOT NULL,
    geo_type text NOT NULL,
    data_source text NOT NULL
);


ALTER TABLE public.cmnty_symptoms OWNER TO postgres;

--
-- Name: covidcast_fb_survey_results; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.covidcast_fb_survey_results (
    survey_date date NOT NULL,
    state text NOT NULL,
    mask_wearing_pct numeric NOT NULL,
    mask_wearing_stderr numeric NOT NULL,
    mask_wearing_sample_size integer NOT NULL,
    symptoms_pct numeric NOT NULL,
    symptoms_stderr numeric NOT NULL,
    symptoms_sample_size integer NOT NULL,
    cmnty_symptoms_pct numeric NOT NULL,
    cmnty_symptoms_stderr numeric NOT NULL,
    cmnty_symptoms_sample_size integer NOT NULL,
    CONSTRAINT covidcast_fb_survey_results_chk_cmnty_symptoms_pct CHECK (((cmnty_symptoms_pct >= (0)::numeric) AND (cmnty_symptoms_pct <= (100)::numeric))),
    CONSTRAINT covidcast_fb_survey_results_chk_cmnty_symptoms_sample_size CHECK ((cmnty_symptoms_sample_size > 0)),
    CONSTRAINT covidcast_fb_survey_results_chk_cmnty_symptoms_stderr CHECK ((cmnty_symptoms_stderr > (0)::numeric)),
    CONSTRAINT covidcast_fb_survey_results_chk_mask_wearing_pct CHECK (((mask_wearing_pct >= (0)::numeric) AND (mask_wearing_pct <= (100)::numeric))),
    CONSTRAINT covidcast_fb_survey_results_chk_mask_wearing_sample_size CHECK ((mask_wearing_sample_size > 0)),
    CONSTRAINT covidcast_fb_survey_results_chk_mask_wearing_stderr CHECK ((mask_wearing_stderr > (0)::numeric)),
    CONSTRAINT covidcast_fb_survey_results_chk_symptoms_pct CHECK (((symptoms_pct >= (0)::numeric) AND (symptoms_pct <= (100)::numeric))),
    CONSTRAINT covidcast_fb_survey_results_chk_symptoms_sample_size CHECK ((symptoms_sample_size > 0)),
    CONSTRAINT covidcast_fb_survey_results_chk_symptoms_stderr CHECK ((symptoms_stderr > (0)::numeric))
);


ALTER TABLE public.covidcast_fb_survey_results OWNER TO postgres;

--
-- Name: covidcast_fb_survey_results_v; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.covidcast_fb_survey_results_v AS
 SELECT covidcast_fb_survey_results.survey_date,
    covidcast_fb_survey_results.state,
    covidcast_fb_survey_results.mask_wearing_pct,
    covidcast_fb_survey_results.cmnty_symptoms_pct AS symptoms_pct
   FROM public.covidcast_fb_survey_results;


ALTER TABLE public.covidcast_fb_survey_results_v OWNER TO postgres;

--
-- Name: covidcast_names; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.covidcast_names (
    csv_file text NOT NULL,
    staging_table text NOT NULL,
    signal text NOT NULL
);


ALTER TABLE public.covidcast_names OWNER TO postgres;

--
-- Name: mask_wearers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mask_wearers (
    code integer NOT NULL,
    geo_value text NOT NULL,
    signal text NOT NULL,
    time_value date NOT NULL,
    direction text,
    issue date NOT NULL,
    lag integer NOT NULL,
    value numeric NOT NULL,
    stderr numeric NOT NULL,
    sample_size numeric NOT NULL,
    geo_type text NOT NULL,
    data_source text NOT NULL
);


ALTER TABLE public.mask_wearers OWNER TO postgres;

--
-- Name: symptoms; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.symptoms (
    code integer NOT NULL,
    geo_value text NOT NULL,
    signal text NOT NULL,
    time_value date NOT NULL,
    direction text,
    issue date NOT NULL,
    lag integer NOT NULL,
    value numeric NOT NULL,
    stderr numeric NOT NULL,
    sample_size numeric NOT NULL,
    geo_type text NOT NULL,
    data_source text NOT NULL
);


ALTER TABLE public.symptoms OWNER TO postgres;

--
-- Name: t; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.t (
    k integer NOT NULL,
    x double precision,
    y double precision,
    delta double precision
);


ALTER TABLE public.t OWNER TO postgres;

--
-- Name: cmnty_symptoms cmnty_symptoms_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cmnty_symptoms
    ADD CONSTRAINT cmnty_symptoms_pk PRIMARY KEY (geo_value, time_value);


--
-- Name: covidcast_fb_survey_results covidcast_fb_survey_results_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.covidcast_fb_survey_results
    ADD CONSTRAINT covidcast_fb_survey_results_pk PRIMARY KEY (state, survey_date);


--
-- Name: covidcast_names covidcast_names_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.covidcast_names
    ADD CONSTRAINT covidcast_names_pkey PRIMARY KEY (csv_file);


--
-- Name: mask_wearers mask_wearers_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mask_wearers
    ADD CONSTRAINT mask_wearers_pk PRIMARY KEY (geo_value, time_value);


--
-- Name: symptoms symptoms_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.symptoms
    ADD CONSTRAINT symptoms_pk PRIMARY KEY (geo_value, time_value);


--
-- Name: t t_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.t
    ADD CONSTRAINT t_pkey PRIMARY KEY (k);


--
-- Name: covidcast_names_signal_unq; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX covidcast_names_signal_unq ON public.covidcast_names USING btree (signal);


--
-- Name: covidcast_names_staging_table_unq; Type: INDEX; Schema: public; Owner: postgres
--

CREATE UNIQUE INDEX covidcast_names_staging_table_unq ON public.covidcast_names USING btree (staging_table);


--
-- PostgreSQL database dump complete
--

