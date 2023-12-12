CREATE OR REPLACE PROCEDURE public_test.util_createallow_NNB_singletable(
  	IN _schema_name text,
	IN _table_name text,
	IN _role_name text)
LANGUAGE 'plpgsql'
AS $BODY$

BEGIN 
	 EXECUTE FORMAT(
		 
		E'CREATE POLICY NNB_allow
    ON %I.%I
    AS PERMISSIVE
    FOR ALL
    TO %I
    USING (
      (
        (
          ("FormDate" < (CURRENT_DATE - \'3 years\'::interval year)) 
          AND 
          ("ProjectKey" ~~* \'NWERN%%\'::text)
        ) 
        OR ("ProjectKey" ~~* \'NDOW%%\'::text) 
        OR ("ProjectKey" ~~ \'BLM_AIM%%\'::text)
      )
    );',
    _schema_name,
	_table_name, 
	_role_name
    );

END
$BODY$;
ALTER PROCEDURE public_test.util_project_key_update(text, text)
    OWNER TO kris;