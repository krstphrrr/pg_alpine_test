CREATE OR REPLACE FUNCTION public_test.util_project_key_drop_ret(_schema_name text, _table_name text, _project_key text, OUT success bool)
  RETURNS bool
  LANGUAGE plpgsql as 
 $function$
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
$function$