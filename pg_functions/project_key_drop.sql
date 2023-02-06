CREATE OR REPLACE FUNCTION public_test.util_project_key_drop_ret(_schema_name text, _table_name text, _project_key text, OUT success bool)
  RETURNS bool
  LANGUAGE plpgsql as 
 $function$
 DECLARE 
  pk_const_name text;
  fk_const_name text;
BEGIN 
-- variable assignment for dropping foreign keys according to the table queried
  CASE _table_name
    WHEN 'dataGap' THEN 
      fk_const_name := 'dataGap_PrimaryKey_fkey'
    WHEN 'dataHeader' THEN
      pk_const_name := 'dataHeader_pkey'
    WHEN 'dataHeight' THEN 
      fk_const_name := 'dataHeight_PrimaryKey_fkey'
    WHEN 'dataHorizontalFlux' THEN 
      fk_const_name := 'dataHorizontalFlux_PrimaryKey_fkey'
    WHEN 'dataLPI' THEN 
      fk_const_name := 'dataLPI_PrimaryKey_fkey'
    WHEN 'dataSoilStability' THEN 
      fk_const_name := 'dataSoilStability_PrimaryKey_fkey'
    WHEN 'dataSpeciesInventory' THEN 
      fk_const_name := 'dataSpeciesInventory_PrimaryKey_fkey'
    WHEN 'geoIndicators' THEN 
      fk_const_name := 'geoIndicators_PrimaryKey_fkey'
    WHEN 'geoSpecies' THEN 
      fk_const_name := 'geoSpecies_PrimaryKey_fkey'
  END CASE 
-- dropping foreign key contraint 
    
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

END
$function$