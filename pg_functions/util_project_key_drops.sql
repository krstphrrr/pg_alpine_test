CREATE OR REPLACE PROCEDURE public_test.util_project_key_drops(_schema_name text, _table_names text[], _project_keys text[])
  LANGUAGE plpgsql
AS $procedure$
DECLARE 
  _table_name TEXT;
  _project_key TEXT;
  _updated_table_names TEXT[];
BEGIN
-- dropping constraints
  CALL public_test.util_constraint_modify_header('down');
  FOREACH _table_name IN ARRAY _table_names
  LOOP
    FOREACH _project_key IN ARRAY _project_keys
    LOOP
      PERFORM public_test.util_project_key_drop_ret(_schema_name, _table_name, _project_key);
    END LOOP;
  END LOOP;
--  reestablishing constraints
  CALL public_test.util_constraint_modify_header('up');
--   update table array to remove dataHeader
  _updated_table_names := ARRAY_REMOVE(_table_names, 'dataHeader');
	FOREACH _table_name IN ARRAY _updated_table_names
	  LOOP
		EXECUTE FORMAT('
			CALL public_test.util_constraint_modify_notheader(''%1$s'',''%2$s'', ''up'');
		', _schema_name, _table_name);
	  END LOOP;
END
$procedure$
