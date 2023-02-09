CREATE OR REPLACE PROCEDURE public_test.util_project_key_update(_schema_name text, _table_name text)
  LANGUAGE plpgsql as 
 $procedure$
BEGIN 
	 EXECUTE FORMAT('
		UPDATE 
		   %I.%I 
		SET "ProjectKey" = REGEXP_REPLACE (
      "ProjectKey",
     ''-'',
     ''_''
   );', 
	    _schema_name, 
		_table_name);

END
$procedure$