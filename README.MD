## PG TESTS 

# mini migration (header,indicators, shapefiles)

1. pg_dump table structures from production db
2. export content into csv 
3. create structure in new local db/schema
4. import content 

# postingestion workflow 

1. add mlra_name, mlrarsym, ecoregions, states
2. populate fields with geofunction
3. fix alaska