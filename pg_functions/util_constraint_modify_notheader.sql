CREATE OR REPLACE PROCEDURE public_test.util_constraint_modify_notheader(_schema_name text, _table_name text, _switch text)
  LANGUAGE plpgsql
AS $procedure$
DECLARE 
--   _table_name TEXT;
--   _project_key TEXT;
	k_const_name TEXT;
BEGIN
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
  	CASE
	  WHEN _switch = 'up' THEN
		EXECUTE FORMAT('
		ALTER TABLE %1$s."%2$s"
		ADD CONSTRAINT "%3$s" 
		FOREIGN KEY ("PrimaryKey") 
		REFERENCES %1$s."dataHeader" ("PrimaryKey");
		', _schema_name, _table_name, k_const_name);
	  WHEN _switch = 'down' THEN
		EXECUTE FORMAT('
		ALTER TABLE %1$s."%2$s"
		DROP CONSTRAINT IF EXISTS "%3$s" CASCADE;
		', _schema_name, _table_name, k_const_name);
	
  	END CASE; 
	
END
$procedure$