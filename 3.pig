-- Loads the state, feature and populated_place tables.
RUN /vol/automed/data/usgs/load_tables.pig

-- Project the attributes needed for this scheme.
feature_with_relevant_attributes = 
    FOREACH feature
    GENERATE state_name, county, type;
        
-- Grouping by county. 
group_features =
    GROUP feature_with_relevant_attributes
    BY (state_name, county);
	
-- Generate aggregates.
aggregates_in_grouped_features =
    FOREACH group_features {
        type_ppl = 
	    FILTER feature_with_relevant_attributes
	    BY type == 'ppl';
	type_str = 
            FILTER feature_with_relevant_attributes
	    BY type == 'stream';
	    
   	    GENERATE group.state_name as state_name,
		     group.county as county,
		     COUNT(type_ppl.type) AS no_ppl,
		     COUNT(type_str.type) AS no_stream;
    }

-- Sorting the grouped relation above by state_name and county.
sorted_by_state_name_and_county = 
    ORDER aggregates_in_grouped_features 
    BY state_name ASC, county ASC;
	
STORE sorted_by_state_name_and_county INTO 'q3' USING PigStorage(',');

