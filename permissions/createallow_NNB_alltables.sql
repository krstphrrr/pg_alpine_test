CREATE OR REPLACE PROCEDURE public_test.util_createallows_NNB_alltables(
	IN _schema_name text,
  IN _user_name text)
LANGUAGE 'plpgsql'
AS $BODY$
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
                  ];
  -- function that accepts rule, user, schema
  FOREACH _table_name IN ARRAY _table_names
  LOOP
    call  public_test.util_createallow_NNB_update(_schema_name, _table_name, _user_name );
  END LOOP;
END
$BODY$;
