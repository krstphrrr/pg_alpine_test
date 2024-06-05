/*
procedure to execute a single permission removal procedure 
throughout a list of tables

args: schema, user, permission

ex. call public_test.util_dynamic_permission_remove_alltables('public_test', 'ndow_test_role', 'nwern')

*/
CREATE OR REPLACE PROCEDURE public_test.util_dynamic_perm__alltables(
	IN _schema_name text,
  IN _role_name text, 
  IN _permission text)
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
  RAISE NOTICE 'removed: % permission policies', _permission;
  RAISE NOTICE 'for % role', _permission;
  -- function that accepts rule, user, schema
  FOREACH _table_name IN ARRAY _table_names
  LOOP
    call  public_test.public_test.dynamic_perm_singletable(_schema_name, _table_name, _role_name, _permission );
    RAISE NOTICE 'on %I table', _table_name;
  END LOOP;
END
$BODY$;