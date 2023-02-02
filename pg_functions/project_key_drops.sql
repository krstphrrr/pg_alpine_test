CREATE OR REPLACE PROCEDURE public_test.util_project_key_drops(_schema_name text, _table_names text[], _project_keys text[])
  LANGUAGE plpgsql
AS $procedure$
DECLARE 
  _table_name TEXT;
  _project_key TEXT;
BEGIN
  FOREACH _table_name IN ARRAY _table_names
  LOOP
    FOREACH _project_key IN ARRAY _project_keys
    LOOP
      CALL public_test.util_project_key_drop(_schema_name, _table_name, _project_key);
    END LOOP;
  END LOOP;
END

