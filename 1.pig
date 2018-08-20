-- Loads the state, feature and populated_place tables.
RUN /vol/automed/data/usgs/load_tables.pig

-- Enforces consistency by making all state_names upper case and at the same time optimises the script by getting rid of the fields that we are not going to use later on.
upper_feature_state_names_bag = 
	FOREACH feature GENERATE UPPER(state_name) AS upper_state_name; 

-- Holds the left join of features with states.
features_and_states_bag = 
	JOIN upper_feature_state_names_bag BY upper_state_name LEFT, 
	state BY name; 

-- Holds features that their states do not match state names so they are filled by NULLs.
features_without_states_bag = 
	FILTER features_and_states_bag 
	BY state::name IS NULL; 

-- Projects resulting states found above.
ordered_features_state_names_bag =
	FOREACH features_without_states_bag
	GENERATE upper_state_name;

-- Get the distinct state_names.
distinct_ordered_features_state_names = 
	DISTINCT ordered_features_state_names_bag;

-- Order results by state name.
ordered_features_without_states =
	ORDER distinct_ordered_features_state_names BY upper_state_name ASC;

STORE ordered_features_without_states INTO 'q1' USING PigStorage(',');

