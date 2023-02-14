CREATE OR REPLACE FUNCTION public_test.postingest_populate_landcover(_schema_name text)
  RETURNS boolean
  LANGUAGE plpgsql
AS $function$
DECLARE
  target_schema TEXT;
  field_exists BOOL;
BEGIN
  target_schema := _schema_name;

  EXECUTE FORMAT('WITH dh AS (
	  SELECT * FROM %1$s."dataHeader" 
  ), 
  ras AS (
    SELECT dh."PrimaryKey", public.ST_VALUE(rastr.rast,1,dh.wkb_geometry) 
    FROM gis.modisraster AS rastr
    JOIN dh 
    ON public.ST_INTERSECTS(
      dh.wkb_geometry, 
        public.ST_CONVEXHULL(rastr.rast)
      )
  ), 
  lg as (
    SELECT ras."PrimaryKey", leg."Name"
    FROM gis.modis_classes AS leg
    JOIN ras 
    ON ras.st_value = leg."Value"
  )
  UPDATE %1$s."geoIndicators" AS ge
  SET modis_landcover = lg."Name"
  FROM lg
  WHERE ge."PrimaryKey" = lg."PrimaryKey";
  ',target_schema );
  return true;

END
$function$