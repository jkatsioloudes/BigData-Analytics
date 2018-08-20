-- Loads the state, feature and populated_place tables.
RUN /vol/automed/data/usgs/load_tables.pig
    
-- Joins population::state_code with state::code to get the state name.
join_of_state_codes_to_get_state_name =
    JOIN populated_place BY state_code,
    state BY code;
    
-- Projects the relevant attributes needed after the group to optimise the script.
project_using_state_name = 
    FOREACH join_of_state_codes_to_get_state_name
    GENERATE state::name, populated_place::name, populated_place::population;

-- Groups populated places by state name.
group_by_state_name_populated_place_name =
    GROUP project_using_state_name
    BY (state::name, populated_place::name);
    
-- Counts population for each place in every state.
count_population_for_each_place_in_every_state =
    FOREACH group_by_state_name_populated_place_name
    GENERATE group.state::name AS state_name,
             group.populated_place::name AS name,
             COUNT(project_using_state_name.population) AS population;
        
-- Orders population in each group found above to enable the use of limit.
order_groups_of_states_and_population =
    ORDER count_population_for_each_place_in_every_state 
    BY state_name ASC, population DESC, name ASC;

-- Limit the top 5 population for each state BUT currently returning just the first 5 tuples of the previous one and not 5 of each state.
limit_population =
    LIMIT order_groups_of_states_and_population 5;
    
STORE limit_population INTO 'q4' USING PigStorage(',');

