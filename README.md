The tables of the usgs database provided by US Geographical Survey are available as a set of TSV files, each containing a table of data.

The state table contains all states and administratively equivalent entities within the USA. Each state has a number of habitations recorded in the populated place table. The type column of feature identifies the type of geographic feature, such as forest, dam, lake, and include some classified as populated places under type ppl. Note that the data is not very ‘clean’, meaning that there are foreign keys not present that intuitively might expected to be present, and there is a certain amount of inconsistency between data found in the ferature and populated place tables.

Run a script:
pig −x local q0.pig

1. A Pig script that writes a CSV file with the scheme (state name) containing all those state names in feature for which there are no corresponding records in state. The result must be ordered by state name, return the names found in upper case, should assume all records in state are in upper case, and ignore difference in case between the two tables.

2. A Pig script that writes a CSV file with the scheme (state name,population,elevation) that returns in order of state name the sum of the population and the average elevation of all populated place data in a given state. The result must be ordered by state name, and elevation data must be rounded to the nearest integer.
             marks 20
3. A Pig script that writes a CSV file with the scheme (state name,county,no ppl,no stream) the number of populated places and the number of streams recorded in feature in each county. The result must be ordered by state name and county.

4. A Pig script that writes a CSV file with the scheme (state name,name,population) containing the state name and place name of each populated place, returning only the five largest populated places in each state. The result must be ordered by state name, with places in each state listed in declining order of population. If populations agree, then order of name should be used.