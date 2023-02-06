CREATE OR REPLACE PROCEDURE public_test.util_project_key_updates(_schema_name text)
  LANGUAGE plpgsql
AS $procedure$
DECLARE 
  _table_name TEXT;
BEGIN
  FOREACH _table_name IN ARRAY _table_names
  LOOP
    call public_test.util_project_key_update(_schema_name, 
      ARRAY[
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
      ]);
  END LOOP;
END
$procedure$
