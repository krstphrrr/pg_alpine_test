CREATE OR REPLACE PROCEDURE public_test.util_constraint_modify_header(IN _schema_name text, IN _switch text)
 LANGUAGE plpgsql
AS $procedure$
-- DECLARE 
--   _table_name TEXT;
--   _project_key TEXT;
BEGIN
  CASE 
    WHEN _switch = 'up' THEN
      EXECUTE FORMAT('
        ALTER TABLE %1$s."dataHeader"
        ADD CONSTRAINT "dataHeader_pkey"
        PRIMARY KEY ("PrimaryKey");
        ',_schema_name);
          
    WHEN _switch = 'down' THEN
      EXECUTE FORMAT('
      ALTER TABLE %1$s."dataHeader"
      DROP CONSTRAINT IF EXISTS 
        "dataHeader_pkey" CASCADE;
      ',_schema_name)
  END CASE;
END
$procedure$