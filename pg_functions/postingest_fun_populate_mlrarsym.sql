CREATE OR REPLACE FUNCTION public_test.postingest_populate_mlrarsym(_schema_name text)
-- populates mlrarsym field if it exists
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
            AND column_name = ''mlrarsym'')', target_schema) 
	INTO field_exists;
 IF field_exists IS TRUE
 THEN
  EXECUTE format(
    'UPDATE %I."geoIndicators" as target
   SET mlrarsym = src.mlrarsym 
   FROM (
      SELECT geo.mlra_name, dh."PrimaryKey", geo.mlrarsym
      FROM gis.mlra_v42_wgs84 as geo 
      JOIN %I."dataHeader" as dh 
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