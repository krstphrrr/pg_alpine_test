CREATE OR REPLACE PROCEDURE public_test.util_dynamic_createallows_alltables(
	IN _schema_name text,
  IN _role_name text, 
  IN _permissions text[])
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
                    'dataPlotCharacterization',
                    'dataSoilHorizons',
                    'dataSoilStability',
                    'dataSpeciesInventory',
                    'geoIndicators',
                    'geoSpecies',
                    'tblRHEM'
                  ];
  -- function that accepts rule, user, schema
  FOREACH _table_name IN ARRAY _table_names
  LOOP
    call  public_test.util_dynamic_createallow_singletables(_schema_name, _role_name, _table_name, _permissions );
  END LOOP;
END
$BODY$;