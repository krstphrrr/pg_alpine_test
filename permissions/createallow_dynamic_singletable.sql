CREATE OR REPLACE PROCEDURE public_test.util_dynamic_createallow_singletable(
  IN _schema_name text,
	IN _role_name text,
	IN _table_name text,
  IN _permissions text[])
LANGUAGE 'plpgsql'
AS $BODY$
DECLARE
  _default_perm_name text;
  _default_query text;
  _default_replacement text;
  _default_end text;
  _perm text;

  _NDOWSTR text;
  _NWERNSTR text;
  _BLMSTR text;

  _default_NDOW text;
  _default_NWERN text;
  _default_BLM text;

BEGIN 
  -- begining of query that will be executed
  _default_query := '
		CREATE POLICY %I
    ON %I.%I
    AS PERMISSIVE
    FOR ALL
    TO %I
    USING';
  -- assigning default values for permissions to keep logic clean
  _default_BLM := E'("ProjectKey" ~~ \'BLM_AIM%%\'::text)';
  _default_NDOW := E'("ProjectKey" ~~* \'NDOW%%\'::text)';
  _default_NWERN := E'(("FormDate" < (CURRENT_DATE - \'3 years\'::interval year)) AND ("ProjectKey" ~~* \'NWERN%%\'::text))';
  -- assigning values that are used for policy name
  _default_perm_name := 'allow_';
  _NDOWSTR := 'nD';
  _NWERNSTR := 'nW';
  _BLMSTR := 'BL';
  -- assigning values used for the dynamic part of the query
  _default_replacement := 'USING ((';
  _default_end := '));';

  -- beginning of forloop
  FOREACH _perm IN ARRAY _permissions 
  
  LOOP 
  -- if permission is on start of array...
  IF array_position(_permissions, _perm) = 1
    THEN 
      CASE 
        WHEN _perm ~~* 'ndow' THEN 
        _default_perm_name := CONCAT(_default_perm_name, _NDOWSTR);
		    _default_replacement := CONCAT(_default_replacement, _default_NDOW); 
        WHEN _perm ~~* 'nwern' THEN 
        _default_perm_name := CONCAT(_default_perm_name, _NWERNSTR);
        _default_replacement := CONCAT(_default_replacement, _default_NWERN); 
        WHEN _perm ~~* 'blm' THEN 
        _default_perm_name := CONCAT(_default_perm_name, _BLMSTR);
        _default_replacement := CONCAT(_default_replacement, _default_BLM); 
      END CASE;
  ELSIF 
    --  if persmission is neither on start of array or end of array
    ARRAY_POSITION(_permissions, _perm) <> 1 
    AND
    ARRAY_POSITION(_permissions, _perm) <> ARRAY_UPPER(_permissions, 1)
    THEN
      -- add or with concat
      _default_replacement := CONCAT(_default_replacement, ' OR ');
	  
      CASE 
        WHEN _perm ~~* 'ndow' THEN 
        _default_perm_name := CONCAT(_default_perm_name, _NDOWSTR);
        _default_replacement := CONCAT(_default_replacement, _default_NDOW); 
        WHEN _perm ~~* 'nwern' THEN 
        _default_perm_name := CONCAT(_default_perm_name, _NWERNSTR);
        _default_replacement := CONCAT(_default_replacement, _default_NWERN);
        WHEN _perm ~~* 'blm' THEN 
        _default_perm_name := CONCAT(_default_perm_name, _BLMSTR);
        _default_replacement := CONCAT(_default_replacement, _default_BLM); 
      END CASE;
  ELSIF 
    -- if permission is at end of array
    ARRAY_POSITION(_permissions, _perm) <> 1 
    AND
    ARRAY_POSITION(_permissions, _perm) = ARRAY_UPPER(_permissions, 1)
    THEN
	  _default_replacement := CONCAT(_default_replacement, ' OR ');
      CASE 
        WHEN _perm ~~* 'ndow' THEN 
        _default_perm_name := CONCAT(_default_perm_name, _NDOWSTR);
        _default_replacement := CONCAT(_default_replacement, _default_NDOW); 
        WHEN _perm ~~* 'nwern' THEN 
        _default_perm_name := CONCAT(_default_perm_name, _NWERNSTR);
        _default_replacement := CONCAT(_default_replacement, _default_NWERN); 
        WHEN _perm ~~* 'blm' THEN 
        _default_perm_name := CONCAT(_default_perm_name, _BLMSTR);
        _default_replacement := CONCAT(_default_replacement, _default_BLM); 
      END CASE;
      _default_replacement := CONCAT(_default_replacement, _default_end);

  END IF;
  END LOOP;
  -- replace default query substring with dynamically created one
  _default_query := REPLACE(_default_query, 'USING', _default_replacement);
  
  -- execute concatenated query
	 EXECUTE FORMAT(_default_query,
    _default_perm_name,
    _schema_name,
	  _table_name, 
		_role_name);

END
$BODY$;