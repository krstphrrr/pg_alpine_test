-- produced the columns with VrA+4#cQZmOT


CREATE OR REPLACE FUNCTION public_test.util_project_key_drop_ret(
	_schema_name text,
	_table_name text,
	_project_key text,
	OUT success boolean)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
 DECLARE res bigint;
BEGIN 
	 EXECUTE FORMAT('
		DELETE 
		FROM %I.%I 
		WHERE "ProjectKey" = $1 RETURNING TRUE;', 
	    _schema_name, 
		_table_name, 
		_project_key)
		USING _project_key 
		INTO success;
-- 		return;

END
$BODY$;

ALTER FUNCTION public_test.util_project_key_drop_ret(text, text, text)
    OWNER TO kris;

-- 
-- call public_test.util_project_key_drops('public_test', 
-- ARRAY["dataDustDeposition", "dataGap",
-- "dataHeader", "dataHeight",
-- "dataHorizontalFlux", "dataLPI",
-- "dataSoilStability", "dataSpeciesInventory",
-- "geoIndicators", "geoSpecies"],
-- ARRAY["BLM_AIM"] 
-- )

CREATE OR REPLACE PROCEDURE public_test.util_project_key_drops(
	IN _schema_name text,
	IN _table_names text[],
	IN _project_keys text[])
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE 
  _table_name TEXT;
  _project_key TEXT;
  _updated_table_names TEXT[];
BEGIN
-- dropping constraints
  CALL public_test.util_constraint_modify_header(_schema_name,'down');
  FOREACH _table_name IN ARRAY _table_names
  LOOP
    FOREACH _project_key IN ARRAY _project_keys
    LOOP
      PERFORM public_test.util_project_key_drop_ret(_schema_name, _table_name, _project_key);
    END LOOP;
  END LOOP;
--  reestablishing constraints
  CALL public_test.util_constraint_modify_header(_schema_name, 'up');
--   update table array to remove dataHeader
  _updated_table_names := ARRAY_REMOVE(_table_names, 'dataHeader');
	FOREACH _table_name IN ARRAY _updated_table_names
	  LOOP
		EXECUTE FORMAT('
			CALL public_test.util_constraint_modify_notheader(''%1$s'',''%2$s'', ''up'');
		', _schema_name, _table_name);
	  END LOOP;
END
$BODY$;
ALTER PROCEDURE public_test.util_project_key_drops(text, text[], text[])
    OWNER TO kris;
