CREATE OR REPLACE FUNCTION public_test.util_project_key_drop_ret(_schema_name text, _table_name text, _project_key text, OUT success bool)
  RETURNS bool
  LANGUAGE plpgsql as 
 $function$
 DECLARE 
  k_const_name text;
BEGIN 
-- variable assignment for dropping foreign keys according to the table queried
  CASE 
    WHEN _table_name = 'dataGap' THEN 
      k_const_name := 'dataGap_PrimaryKey_fkey';
    WHEN _table_name = 'dataHeader' THEN
      k_const_name := 'dataHeader_pkey';
    WHEN _table_name = 'dataHeight' THEN 
      k_const_name := 'dataHeight_PrimaryKey_fkey';
    WHEN _table_name = 'dataHorizontalFlux' THEN 
      k_const_name := 'dataHorizontalFlux_PrimaryKey_fkey';
    WHEN _table_name = 'dataLPI' THEN 
      k_const_name := 'dataLPI_PrimaryKey_fkey';
    WHEN _table_name = 'dataSoilStability' THEN 
      k_const_name := 'dataSoilStability_PrimaryKey_fkey';
    WHEN _table_name = 'dataSpeciesInventory' THEN 
      k_const_name := 'dataSpeciesInventory_PrimaryKey_fkey';
    WHEN _table_name = 'geoIndicators' THEN 
      k_const_name := 'geoIndicators_PrimaryKey_fkey';
    WHEN _table_name = 'geoSpecies' THEN 
      k_const_name := 'geoSpecies_PrimaryKey_fkey';
  END CASE;
-- dropping foreign key contraint 
    IF _table_name = 'dataHeader' 
    THEN
  -- if table is header drop primarykey constraint
    EXECUTE FORMAT('
      ALTER TABLE %I.%I
      DROP CONSTRAINT IF EXISTS %I CASCADE;
    ', _schema_name, _table_name, k_const_name);
  ELSE
  -- else drop foreign key constraint
    EXECUTE FORMAT('
      ALTER TABLE %I.%I
      DROP CONSTRAINT IF EXISTS %I CASCADE;
    ', _schema_name, _table_name, k_const_name);
  END IF;
-- dropping the rows
	 EXECUTE FORMAT('
		DELETE 
		FROM %I.%I 
		WHERE "ProjectKey" = $1 RETURNING TRUE;', 
	    _schema_name, 
		_table_name, 
		_project_key)
		USING _project_key 
		INTO success;
-- reestablishing foreign key constraint
-- adding key contraint 
  IF _table_name = 'dataHeader' 
    THEN
  -- if table is header add primarykey constraint
    EXECUTE FORMAT('
      ALTER TABLE %I.%I
      ADD CONSTRAINT %I
      PRIMARY KEY ("PrimaryKey");
    ', _schema_name, _table_name, k_const_name);
  ELSE
  -- else add foreign key constraint
    EXECUTE FORMAT('
      ALTER TABLE %I.%I
      ADD CONSTRAINT %I
      FOREIGN KEY ("PrimaryKey")
      REFERENCES %I."dataHeader" ("PrimaryKey");
    ', _schema_name, _table_name, k_const_name, _schema_name);
  END IF;
    
END
$function$