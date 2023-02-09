CREATE OR REPLACE PROCEDURE public_test.util_project_key_updates(_schema_name text)
  LANGUAGE plpgsql
AS $procedure$
DECLARE 
  _table_name TEXT;
  _table_names TEXT[];

BEGIN
  _table_names := ARRAY[
                    'dataDustDeposition',
                    'dataGap',
                    'dataHeader',
                    'dataHeight',
                    'dataHorizontalFlux',
                    'dataLPI',
                    'dataSoilStability',
                    'dataSpeciesInventory',
                    'geoIndicators',
                    'geoSpecies'
                  ]
  FOREACH _table_name IN ARRAY _table_names
  LOOP
    call public_test.util_project_key_update(_schema_name, _table_name);
  END LOOP;
END
$procedure$
