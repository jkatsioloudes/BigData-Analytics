-- Loads the state, feature and populated_place tables.
RUN /vol/automed/data/usgs/load_tables.pig

-- Joins populated_place::state_code with state::code.  Not here that we are going to make use of the built in pig optimisation that the attributes not needed later are going to be eliminated by pig so we dont need to project before the join.
populated_place_join_state_by_state_code = 
	JOIN populated_place BY state_code,
	state BY code;

-- Projects the 3 attributes we are interested in before grouping which is an optimisation.
projection_state_name_population_elevation =
	FOREACH populated_place_join_state_by_state_code
	GENERATE state::name, populated_place::population, populated_place::elevation;

-- Grouping by state_name.
group_by_state_name =
	GROUP projection_state_name_population_elevation
	BY state::name;

-- Aggregate on the above grouping.
sum_population_and_avg_elevation = 
	FOREACH group_by_state_name
	GENERATE group AS state_name,
   		 SUM(projection_state_name_population_elevation.population) AS population,
	   	 ROUND(AVG(projection_state_name_population_elevation.elevation)) AS elevation;

-- Sort the results by state_name.
sort_sum_population_and_avg_elevation_by_state_name = 
	ORDER sum_population_and_avg_elevation BY state_name ASC;
	
STORE sort_sum_population_and_avg_elevation_by_state_name INTO 'q2' USING PigStorage(',');

