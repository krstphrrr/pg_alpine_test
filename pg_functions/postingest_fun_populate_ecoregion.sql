CREATE OR REPLACE FUNCTION public_test.postingest_populate_ecoregion(_schema_name text)
-- populates ecoregion field if it exists
RETURNS boolean --return true if successful, false if not
 LANGUAGE plpgsql
AS $function$
DECLARE
  target_schema TEXT;
  field_exists BOOL;
BEGIN
	target_schema := _schema_name;
	
    EXECUTE format(
       'SELECT EXISTS (
          SELECT FROM information_schema.columns
          WHERE table_schema = ''%I''
            AND table_name = ''geoIndicators''
            AND column_name = ''na_l1name''
            AND column_name = ''na_l2name''
            AND column_name = ''us_l3name''
            AND column_name = ''us_l4name'' )', target_schema) 
	INTO field_exists;
 IF field_exists IS TRUE
 THEN
  EXECUTE format('
    UPDATE %I."geoIndicators" AS target
    SET 
        na_l1name = src.na_l1name,
        na_l2name = src.na_l2name,
        us_l3name = src.us_l3name,
        us_l4name = src.us_l4name
    FROM (
        SELECT 
          geo.us_l4name, 
          geo.us_l3name, 
          geo.na_l2name, 
          geo.na_l1name, 
          dh."PrimaryKey"
        FROM gis.us_eco_level_4 AS geo 
        JOIN %I."dataHeader" AS dh 
        ON ST_WITHIN(dh.wkb_geometry, geo.geom)
    ) as src
   WHERE target."PrimaryKey" = src."PrimaryKey";', target_schema, target_schema
  );
  RETURN TRUE;
  ELSE
   RETURN FALSE;
 END IF;
END
$function$