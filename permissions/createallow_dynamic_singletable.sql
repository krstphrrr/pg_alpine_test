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

  _NDOWSTR text; -- deprecated
  _NWERNSTR text;
  _BLMSTR text;
  _DURPSTR text;

  _default_NDOW text; -- deprecated
  _default_NWERN text;
  _default_BLM text;
  _default_DURP text;
  _default_NWERN_default text;
  _default_allowed text;
  _default_empty_permissions text;

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
  _default_NDOW := E'("ProjectKey" ~~* \'NDOW%%\'::text)'; -- deprecated
  _default_NWERN := E'("ProjectKey" ~~* \'NWERN%%\'::text)';

-- ADDED 2024-05-07
  _default_DURP := E'("ProjectKey" ~~* \'%%DURP%%\'::text)';

  _default_NWERN_default := E' OR (("DateVisited" < (CURRENT_DATE - \'3 years\'::interval year)) AND ("ProjectKey" ~~* \'NWERN%%\'::text))';
  -- ALTERED DEFAULTS ++NDOW 2024-06-04
  _default_allowed := E' OR ("ProjectKey" ~~* \'%%murv%%\'::text) OR ("ProjectKey" ~~* \'CRNG%%\'::text) OR ("ProjectKey" ~~* \'NDOW%%\'::text)';
  _default_empty_permissions := E' ("ProjectKey" ~~* \'%%murv%%\'::text) OR ("ProjectKey" ~~* \'CRNG%%\'::text) OR ("ProjectKey" ~~* \'NDOW%%\'::text)';
  -- assigning values that are used for policy name
  _default_perm_name := 'allow_';
  _NDOWSTR := 'nD';
  _NWERNSTR := 'nW';
  _BLMSTR := 'BL';

-- ADDED 2024-05-07
  _DURPSTR := 'Du';
-- 
  -- assigning values used for the dynamic part of the query
  _default_replacement := 'USING ((';
  _default_end := '));';

  -- handle case where table is DustDeposition (no DateVisited)
--   IF (_table_name = 'dataDustDeposition')
--   THEN
--     _default_NWERN_default := REPLACE(_default_NWERN_default,'DateVisited','collectDate');
--   END IF;
  
--   IF (_table_name = 'dataPlotCharacterization')
--   THEN
--     _default_NWERN_default := REPLACE(_default_NWERN_default,'DateVisited','EstablishDate');
--   END IF;
  
--   IF (_table_name = 'tblRHEM') OR (_table_name = 'dataSoilHorizons')
--   THEN
--   	_default_NWERN := ' 1 = 1 ';
--     _default_NWERN_default := ' OR 2 = 1 ';
--   END IF;
  
  -- if permission array is empty
  IF (cardinality(_permissions)<1)
  THEN
  -- add empty string and continue
    _default_replacement := CONCAT(_default_replacement, ' ');

  --  if permission array has anything
  ELSE
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

        -- ADDED 2024-05-07
        WHEN _perm ~~* 'durp' THEN 
        _default_perm_name := CONCAT(_default_perm_name, _DURPSTR);
        _default_replacement := CONCAT(_default_replacement, _default_DURP); 
		  END CASE;
	  ELSIF 
		--  if persmission is neither on start of array or end of array
		ARRAY_POSITION(_permissions, _perm) <> 1 
		AND
		ARRAY_POSITION(_permissions, _perm) <> ARRAY_UPPER(_permissions, 1)
		THEN
		  -- add 'or' 
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

      -- ADDED 2024-05-07
      WHEN _perm ~~* 'durp' THEN 
      _default_perm_name := CONCAT(_default_perm_name, _DURPSTR);
      _default_replacement := CONCAT(_default_replacement, _default_DURP); 
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

      -- ADDED 2024-05-07
      WHEN _perm ~~* 'durp' THEN 
      _default_perm_name := CONCAT(_default_perm_name, _DURPSTR);
      _default_replacement := CONCAT(_default_replacement, _default_DURP); 

		  END CASE;
		END IF;
		END LOOP; 
  END IF;

--   OUTSIDELOOP
--  if permissions are 0
  IF (CARDINALITY(_permissions)<1)
  	THEN
	    _default_replacement := CONCAT(_default_replacement, _default_empty_permissions);
      _default_replacement := CONCAT(_default_replacement, _default_NWERN_default);
      _default_replacement := CONCAT(_default_replacement, _default_end);
-- if permission array > 0
	ELSE
		_default_replacement := CONCAT(_default_replacement, _default_allowed);
-- 		IF (_table_name='tblRHEM') OR (_table_name = 'dataSoilHorizons')
-- 		THEN
-- -- 			_default_allowed := REPLACE(_default_allowed,E' OR ("ProjectKey" ~~* \'Jornada%%\'::text)', E' ("ProjectKey" ~~* \'Jornada%%\'::text)');
-- 			_default_replacement := CONCAT(_default_replacement, _default_allowed);
-- 		ELSE
-- 		  _default_replacement := CONCAT(_default_replacement, _default_allowed);
-- 		END IF;
      IF ('NWERN' LIKE ANY(_permissions))
        THEN
        -- if TRUE, nwern should have been handled. no nwern default added
        _default_replacement := CONCAT(_default_replacement, _default_end);
      ELSIF ('NWERN' NOT LIKE ANY(_permissions))
      -- FALSE, nwern not handled so added default handling (old records allowed)
          THEN
        _default_replacement := CONCAT(_default_replacement, _default_NWERN_default);
        _default_replacement := CONCAT(_default_replacement, _default_end);
      END IF;
  END IF;
  -- dynamically assigning descriptive policy names (allow_permissions_rolename)
  IF (CARDINALITY(_permissions)<1)
  THEN 
    _default_perm_name:=CONCAT(_default_perm_name, 'restricted');
    _default_perm_name:=CONCAT(_default_perm_name, '_');
    _default_perm_name:=CONCAT(_default_perm_name, _role_name);
  ELSE
    _default_perm_name:=CONCAT(_default_perm_name, '_');
    _default_perm_name:=CONCAT(_default_perm_name, _role_name);
  END IF;
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
ALTER PROCEDURE public_test.util_dynamic_createallow_singletable(text, text, text, text[])
    OWNER TO kris;
