CREATE OR REPLACE FUNCTION public_test.postingest_populate_landcover(_schema_name text, _date text)
  RETURNS boolean
  LANGUAGE plpgsql
AS $function$
DECLARE
  target_schema TEXT;
  field_exists BOOL;
  target_date DATE;
BEGIN
  target_schema := _schema_name;
  target_date := TO_DATE(_date, 'YYYYMMDD');

  EXECUTE FORMAT('
  with ras AS (
    SELECT dh."PrimaryKey", public.ST_VALUE(rastr.rast,1,dh.wkb_geometry) 
    FROM gis.modisraster AS rastr
    JOIN (SELECT "PrimaryKey", wkb_geometry from %1$s."dataHeader" where "DateLoadedInDb" between %2$L and now() ) as dh
    ON public.ST_INTERSECTS(
      dh.wkb_geometry, 
        public.ST_CONVEXHULL(rastr.rast)
      )
  ), 
  lg as (
    SELECT ras."PrimaryKey", leg."Name"
    FROM public.modis_classes AS leg
    JOIN ras 
    ON ras.st_value = leg."Value"
  )
  UPDATE %1$s."geoIndicators" AS ge
  SET modis_landcover = lg."Name"
  FROM lg
  WHERE ge."PrimaryKey" = lg."PrimaryKey"
				 AND 
		"DateLoadedInDb" between %2$L and now();
  ',target_schema, target_date );
  return true;

END
$function$