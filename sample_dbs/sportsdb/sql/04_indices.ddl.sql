--
-- Name: idx_addresses_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_addresses_1 ON addresses USING btree (locality);


--
-- Name: idx_addresses_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_addresses_2 ON addresses USING btree (region);


--
-- Name: idx_addresses_3; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_addresses_3 ON addresses USING btree (postal_code);


--
-- Name: idx_affiliations_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_affiliations_1 ON affiliations USING btree (affiliation_key);


--
-- Name: idx_affiliations_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_affiliations_2 ON affiliations USING btree (affiliation_type);


--
-- Name: idx_american_football_action_participants_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_american_football_action_participants_1 ON american_football_action_participants USING btree (participant_role);


--
-- Name: idx_american_football_action_participants_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_american_football_action_participants_2 ON american_football_action_participants USING btree (score_type);


--
-- Name: idx_american_football_action_plays_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_american_football_action_plays_1 ON american_football_action_plays USING btree (play_type);


--
-- Name: idx_american_football_action_plays_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_american_football_action_plays_2 ON american_football_action_plays USING btree (score_attempt_type);


--
-- Name: idx_american_football_action_plays_3; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_american_football_action_plays_3 ON american_football_action_plays USING btree (drive_result);


--
-- Name: idx_american_football_event_states_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_american_football_event_states_1 ON american_football_event_states USING btree (current_state);


--
-- Name: idx_baseball_action_pitches_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_baseball_action_pitches_1 ON baseball_action_pitches USING btree (umpire_call);


--
-- Name: idx_baseball_action_pitches_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_baseball_action_pitches_2 ON baseball_action_pitches USING btree (pitch_type);


--
-- Name: idx_baseball_action_plays_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_baseball_action_plays_1 ON baseball_action_plays USING btree (play_type);


--
-- Name: idx_baseball_event_states_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_baseball_event_states_1 ON baseball_event_states USING btree (current_state);


--
-- Name: idx_db_info_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_db_info_1 ON db_info USING btree (version);


--
-- Name: idx_document_classes_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_document_classes_1 ON document_classes USING btree (name);


--
-- Name: idx_document_fixtures_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_document_fixtures_1 ON document_fixtures USING btree (fixture_key);


--
-- Name: idx_documents_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_documents_1 ON documents USING btree (doc_id);


--
-- Name: idx_documents_3; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_documents_3 ON documents USING btree (date_time);


--
-- Name: idx_documents_4; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_documents_4 ON documents USING btree (priority);


--
-- Name: idx_documents_5; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_documents_5 ON documents USING btree (revision_id);


--
-- Name: idx_events_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_events_1 ON events USING btree (event_key);


--
-- Name: idx_fk_add_loc_id__loc_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_add_loc_id__loc_id ON addresses USING btree (location_id);


--
-- Name: idx_fk_aff_pub_id__pub_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_aff_pub_id__pub_id ON affiliations USING btree (publisher_id);


--
-- Name: idx_fk_ame_foo_act_par_ame_foo_act_pla_id__ame_foo_act_pla_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_ame_foo_act_par_ame_foo_act_pla_id__ame_foo_act_pla_id ON american_football_action_participants USING btree (american_football_action_play_id);


--
-- Name: idx_fk_ame_foo_act_par_per_id__per_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_ame_foo_act_par_per_id__per_id ON american_football_action_participants USING btree (person_id);


--
-- Name: idx_fk_ame_foo_act_pla_ame_foo_eve_sta_id__ame_foo_eve_sta_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_ame_foo_act_pla_ame_foo_eve_sta_id__ame_foo_eve_sta_id ON american_football_action_plays USING btree (american_football_event_state_id);


--
-- Name: idx_fk_ame_foo_eve_sta_eve_id__eve_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_ame_foo_eve_sta_eve_id__eve_id ON american_football_event_states USING btree (event_id);


--
-- Name: idx_fk_bas_act_pit_bas_def_gro_id__bas_def_gro_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_bas_act_pit_bas_def_gro_id__bas_def_gro_id ON baseball_action_pitches USING btree (baseball_defensive_group_id);


--
-- Name: idx_fk_bas_act_pla_bas_eve_sta_id__bas_eve_sta_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_bas_act_pla_bas_eve_sta_id__bas_eve_sta_id ON baseball_action_plays USING btree (baseball_event_state_id);


--
-- Name: idx_fk_bas_eve_sta_eve_id__eve_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_bas_eve_sta_eve_id__eve_id ON baseball_event_states USING btree (event_id);


--
-- Name: idx_fk_doc_con_doc_id__doc_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_doc_con_doc_id__doc_id ON document_contents USING btree (document_id);


--
-- Name: idx_fk_doc_doc_fix_id__doc_fix_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_doc_doc_fix_id__doc_fix_id ON documents USING btree (document_fixture_id);


--
-- Name: idx_fk_doc_fix_doc_cla_id__doc_cla_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_doc_fix_doc_cla_id__doc_cla_id ON document_fixtures USING btree (document_class_id);


--
-- Name: idx_fk_doc_fix_eve_doc_fix_id__doc_fix_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_doc_fix_eve_doc_fix_id__doc_fix_id ON document_fixtures_events USING btree (document_fixture_id);


--
-- Name: idx_fk_doc_fix_eve_eve_id__eve_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_doc_fix_eve_eve_id__eve_id ON document_fixtures_events USING btree (event_id);


--
-- Name: idx_fk_doc_fix_eve_lat_doc_id__doc_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_doc_fix_eve_lat_doc_id__doc_id ON document_fixtures_events USING btree (latest_document_id);


--
-- Name: idx_fk_doc_fix_pub_id__pub_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_doc_fix_pub_id__pub_id ON document_fixtures USING btree (publisher_id);


--
-- Name: idx_fk_doc_pub_id__pub_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_doc_pub_id__pub_id ON documents USING btree (publisher_id);


--
-- Name: idx_fk_doc_sou_id__pub_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_doc_sou_id__pub_id ON documents USING btree (source_id);


--
-- Name: idx_fk_eve_pub_id__pub_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_eve_pub_id__pub_id ON events USING btree (publisher_id);


--
-- Name: idx_fk_eve_sit_id__sit_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_eve_sit_id__sit_id ON events USING btree (site_id);


--
-- Name: idx_fk_events_basketball_event_states; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_events_basketball_event_states ON basketball_event_states USING btree (event_id);


--
-- Name: idx_fk_events_motor_racing_event_states; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_events_motor_racing_event_states ON motor_racing_event_states USING btree (event_id);


--
-- Name: idx_fk_events_soccer_event_states; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_events_soccer_event_states ON soccer_event_states USING btree (event_id);


--
-- Name: idx_fk_events_tennis_event_states; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_events_tennis_event_states ON tennis_event_states USING btree (event_id);


--
-- Name: idx_fk_inj_pha_per_id__per_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_inj_pha_per_id__per_id ON injury_phases USING btree (person_id);


--
-- Name: idx_fk_inj_pha_sea_id__sea_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_inj_pha_sea_id__sea_id ON injury_phases USING btree (season_id);


--
-- Name: idx_fk_lat_rev_lat_doc_id__doc_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_lat_rev_lat_doc_id__doc_id ON latest_revisions USING btree (latest_document_id);


--
-- Name: idx_fk_par_eve_eve_id__eve_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_par_eve_eve_id__eve_id ON participants_events USING btree (event_id);


--
-- Name: idx_fk_per_eve_met_eve_id__eve_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_per_eve_met_eve_id__eve_id ON person_event_metadata USING btree (event_id);


--
-- Name: idx_fk_per_eve_met_per_id__per_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_per_eve_met_per_id__per_id ON person_event_metadata USING btree (person_id);


--
-- Name: idx_fk_per_eve_met_pos_id__pos_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_per_eve_met_pos_id__pos_id ON person_event_metadata USING btree (position_id);


--
-- Name: idx_fk_per_eve_met_rol_id__rol_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_per_eve_met_rol_id__rol_id ON person_event_metadata USING btree (role_id);


--
-- Name: idx_fk_per_par_eve_id__par_eve_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_per_par_eve_id__par_eve_id ON periods USING btree (participant_event_id);


--
-- Name: idx_fk_per_pha_per_id__per_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_per_pha_per_id__per_id ON person_phases USING btree (person_id);


--
-- Name: idx_fk_per_pha_reg_pos_id__pos_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_per_pha_reg_pos_id__pos_id ON person_phases USING btree (regular_position_id);


--
-- Name: idx_fk_per_pub_id__pub_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_per_pub_id__pub_id ON persons USING btree (publisher_id);


--
-- Name: idx_fk_pos_aff_id__aff_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_pos_aff_id__aff_id ON positions USING btree (affiliation_id);


--
-- Name: idx_fk_sea_lea_id__aff_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_sea_lea_id__aff_id ON seasons USING btree (league_id);


--
-- Name: idx_fk_sea_pub_id__pub_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_sea_pub_id__pub_id ON seasons USING btree (publisher_id);


--
-- Name: idx_fk_sit_loc_id__loc_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_sit_loc_id__loc_id ON sites USING btree (location_id);


--
-- Name: idx_fk_sit_pub_id__pub_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_sit_pub_id__pub_id ON sites USING btree (publisher_id);


--
-- Name: idx_fk_sub_per_per_id__per_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_sub_per_per_id__per_id ON sub_periods USING btree (period_id);


--
-- Name: idx_fk_sub_sea_sea_id__sea_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_sub_sea_sea_id__sea_id ON sub_seasons USING btree (season_id);


--
-- Name: idx_fk_teams_person_event_metadata; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_teams_person_event_metadata ON person_event_metadata USING btree (team_id);


--
-- Name: idx_fk_wea_con_eve_id__eve_id; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_fk_wea_con_eve_id__eve_id ON weather_conditions USING btree (event_id);


--
-- Name: idx_injury_phases_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_injury_phases_2 ON injury_phases USING btree (injury_status);


--
-- Name: idx_injury_phases_3; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_injury_phases_3 ON injury_phases USING btree (start_date_time);


--
-- Name: idx_injury_phases_4; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_injury_phases_4 ON injury_phases USING btree (end_date_time);


--
-- Name: idx_key_aliases_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_key_aliases_1 ON key_roots USING btree (key_type);


--
-- Name: idx_key_aliases_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_key_aliases_2 ON key_aliases USING btree (key_id);


--
-- Name: idx_latest_revisions_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_latest_revisions_1 ON latest_revisions USING btree (revision_id);


--
-- Name: idx_locations_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_locations_1 ON locations USING btree (country_code);


--
-- Name: idx_participants_events_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_participants_events_1 ON participants_events USING btree (participant_type);


--
-- Name: idx_participants_events_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_participants_events_2 ON participants_events USING btree (participant_id);


--
-- Name: idx_participants_events_3; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_participants_events_3 ON participants_events USING btree (alignment);


--
-- Name: idx_participants_events_4; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_participants_events_4 ON participants_events USING btree (event_outcome);


--
-- Name: idx_person_event_metadata_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_person_event_metadata_1 ON person_event_metadata USING btree (status);


--
-- Name: idx_person_phases_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_person_phases_1 ON person_phases USING btree (membership_type);


--
-- Name: idx_person_phases_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_person_phases_2 ON person_phases USING btree (membership_id);


--
-- Name: idx_person_phases_3; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_person_phases_3 ON person_phases USING btree (phase_status);


--
-- Name: idx_persons_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_persons_1 ON persons USING btree (person_key);


--
-- Name: idx_positions_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_positions_1 ON positions USING btree (abbreviation);


--
-- Name: idx_publishers_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_publishers_1 ON publishers USING btree (publisher_key);


--
-- Name: idx_roles_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_roles_1 ON roles USING btree (role_key);


--
-- Name: idx_seasons_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_seasons_1 ON seasons USING btree (season_key);


--
-- Name: idx_sites_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_sites_1 ON sites USING btree (site_key);


--
-- Name: idx_stats_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_stats_1 ON stats USING btree (stat_repository_type);


--
-- Name: idx_stats_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_stats_2 ON stats USING btree (stat_repository_id);


--
-- Name: idx_stats_3; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_stats_3 ON stats USING btree (stat_holder_type);


--
-- Name: idx_stats_4; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_stats_4 ON stats USING btree (stat_holder_id);


--
-- Name: idx_stats_5; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_stats_5 ON stats USING btree (stat_coverage_type);


--
-- Name: idx_stats_6; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_stats_6 ON stats USING btree (stat_coverage_id);


--
-- Name: idx_stats_7; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_stats_7 ON stats USING btree (context);


--
-- Name: idx_sub_seasons_1; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_sub_seasons_1 ON sub_seasons USING btree (sub_season_key);


--
-- Name: idx_sub_seasons_2; Type: INDEX; Schema: public; Owner: postgres81; Tablespace: 
--

CREATE INDEX idx_sub_seasons_2 ON sub_seasons USING btree (sub_season_type);
