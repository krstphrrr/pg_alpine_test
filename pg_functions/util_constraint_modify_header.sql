CREATE OR REPLACE PROCEDURE public_test.util_constraint_modify_header(IN _switch text)
 LANGUAGE plpgsql
AS $procedure$
-- DECLARE 
--   _table_name TEXT;
--   _project_key TEXT;
BEGIN
  CASE 
    WHEN _switch = 'up' THEN
      ALTER TABLE public_test."dataHeader"
      ADD CONSTRAINT "dataHeader_pkey"
          PRIMARY KEY ("PrimaryKey");
          
    WHEN _switch = 'down' THEN
      ALTER TABLE public_test."dataHeader"
      DROP CONSTRAINT IF EXISTS "dataHeader_pkey" CASCADE;
  END CASE;
END
$procedure$