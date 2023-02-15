## PG TESTS 

# 02/14/2023 - query plan for public_dev schema

1. drop all chosen project keys from public dev:

```sql
call public_test.util_project_key_drops(
	'public_dev',
	ARRAY[
		'dataGap',
		'dataHeader',
		'dataHeight',
		'dataHorizontalFlux',
		'dataLPI',
		'dataSoilStability',
		'dataSpeciesInventory',
		'geoIndicators',
		'geoSpecies'
	],
	ARRAY[
		'NWERN_Akron',
		'NWERN_CPER',
		'NWERN_ElReno',
		'NWERN_HAFB',
		'NWERN_JER',
		'NWERN_Lordsburg',
		'NWERN_Mandan',
		'NWERN_Moab',
		'NWERN_Morton',
		'NWERN_Pullman',
		'NWERN_RedHills',
		'NWERN_SLV',
		'NWERN_TwinValley'
	]
)
```
2. clean tblproject:

```sql
call public_test.util_project_key_drops_tblproject(
	'public_dev',
	ARRAY[
		'NWERN_Akron',
		'NWERN_CPER',
		'NWERN_ElReno',
		'NWERN_HAFB',
		'NWERN_JER',
		'NWERN_Lordsburg',
		'NWERN_Mandan',
		'NWERN_Moab',
		'NWERN_Morton',
		'NWERN_Pullman',
		'NWERN_RedHills',
		'NWERN_SLV',
		'NWERN_TwinValley'
		]
)
```
3. populate fields individually postingest:

```sql
select public_test.postingest_populate_ecoregion('public_dev')
select public_test.postingest_populate_mlra_name('public_dev')
select public_test.postingest_populate_mlrarsym('public_dev')
select public_test.postingest_populate_state('public_dev')
select public_test.postingest_populate_ecoregion('public_dev')
```
4. ...or populate fields with procedure:

```sql
call public_test.postingest_populate_fields('public_dev')
```


# mini migration (header,indicators, shapefiles)

1. pg_dump table structures from production db
2. export content into csv 
3. create structure in new local db/schema
4. import content 

# postingestion workflow 

1. add mlra_name, mlrarsym, ecoregions, states
2. populate fields with geofunction
3. fix alaska