/*
procedure to remove a single permission dynamically

args: schema, tablename, user, permission

permission will be one of: ndow(deprecated), nwern, blm, durp

ex. call public_test.util_dynamic_permission_remove_singletable('public_test', 'dataGap',  'ndow_test_role', 'nwern')

*/

CREATE OR REPLACE PROCEDURE public_test.dynamic_perm_singletable(
	IN _schema_name text,
	IN _table_name text,
	IN _role_name text, 
  IN _permission text
  )
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE 
  _pkcode text;
  _perm_array text[];

BEGIN 
-- first step
  CASE
    WHEN _permission ~~* 'ndow' THEN
      _pkcode = 'nD';
    WHEN _permission ~~*  'nwern' THEN
      _pkcode = 'nW';
    WHEN _permission ~~* 'blm' THEN
      _pkcode = 'BL';
    WHEN _permission ~~* 'durp' THEN 
      _pkcode = 'Du';
  END CASE;
	RAISE NOTICE 'projectkey used: %', _pkcode;
-- second step: fetch array
  EXECUTE FORMAT('
    SELECT
	  ARRAY_AGG("policyname") 
	  FROM pg_policies 
    WHERE tablename = %L 
    AND schemaname = %L; 
  ', _table_name, _schema_name
  ) INTO 
    _perm_array;
	RAISE NOTICE 'permissions array: %', _perm_array;
--  third step: loop drop policy functions
    FOREACH _permission IN ARRAY _perm_array LOOP
	RAISE NOTICE 'pkcode in permission: %', (_permission ~~ ('%' || _pkcode || '%'));
	RAISE NOTICE 'rolename in permission: %', (_permission ~~ ('%' || _role_name));
      IF ( _permission ~~ ('%' || _pkcode || '%')) AND (_permission ~~ ('%' || _role_name)) THEN
		
        EXECUTE FORMAT(
          E'DROP POLICY IF EXISTS %I ON %I.%I;',
          _permission,
          _schema_name,
          _table_name
        );
		RAISE NOTICE 'PERMISSION: %', _permission;
	  ELSE RAISE NOTICE 'no permission nor role found within array';
      END IF;
    END LOOP;
END
$BODY$;