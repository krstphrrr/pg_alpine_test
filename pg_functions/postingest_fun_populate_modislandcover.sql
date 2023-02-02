CREATE OR REPLACE FUNCTION public_test.postingest_populate_landcover()
  RETURNS BOOL
  LANGUAGE plpgsql
AS $function$
DECLARE
  target_schema TEXT;
  field_exists BOOL;
BEGIN
  target_schema := 'public_test';

  WITH dh AS (
	  SELECT * FROM public_test."dataHeader" 
  ), 
  ras AS (
    SELECT dh."PrimaryKey", ST_VALUE(rastr.rast,1,dh.wkb_geometry) 
    FROM gis.modisraster AS rastr
    JOIN dh 
    ON ST_INTERSECTS(
      dh.wkb_geometry, 
        ST_CONVEXHULL(rastr.rast)
      )
  ), 
  lg as (
    SELECT ras."PrimaryKey", leg."Name"
    FROM gis.modis_classes AS leg
    JOIN ras 
    ON ras.st_value = leg."Value"
  )
  UPDATE public_test."geoIndicators" AS ge
  SET modis_landcover = lg."Name"
  FROM lg
  WHERE ge."PrimaryKey" = lg."PrimaryKey";

END
$function$