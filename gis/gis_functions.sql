-- function migrations for local db; changed location of postgis install from gis to public;

CREATE OR REPLACE FUNCTION public_test.postingest_populate_ecoregion(
	_schema_name text)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
            AND column_name in (''na_l1name'', ''na_l2name'', ''us_l3name'', ''us_l4name''))', target_schema) 
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
        FROM public.us_eco_level_4 AS geo 
        JOIN %I."dataHeader" AS dh 
        ON public.ST_WITHIN(dh.wkb_geometry, geo.geom)
    ) AS src
   WHERE target."PrimaryKey" = src."PrimaryKey";', target_schema, target_schema
  );

  EXECUTE format('
    UPDATE %I."geoIndicators" AS target
    SET 
      na_l1name = src.na_l1name,
      na_l2name = src.na_l2name, 
      us_l3name = src.us_l3name
    FROM (
      SELECT 
        geo.us_l3name,
        geo.na_l2name,
        geo.na_l1name, 
        dh."PrimaryKey"
      FROM public.ak_ecoregions AS geo
      JOIN %I."dataHeader" AS dh
      ON public.ST_WITHIN(dh.wkb_geometry, geo.geom)
    ) AS src 
    WHERE target."PrimaryKey" = src."PrimaryKey";', target_schema, target_schema
  );
  RETURN TRUE;
  ELSE
   RETURN FALSE;
 END IF;
END
$BODY$;



CREATE OR REPLACE FUNCTION public_test.postingest_populate_landcover(
	_schema_name text,
	_date text)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
    FROM public.modisraster AS rastr
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
$BODY$;

CREATE OR REPLACE FUNCTION public_test.postingest_populate_mlra_name(
	_schema_name text)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
            AND column_name = ''mlra_name'')', target_schema) 
	INTO field_exists;
 IF field_exists IS TRUE
 THEN
  EXECUTE format(
    'UPDATE %I."geoIndicators" as target
   SET mlra_name = src.mlra_name 
   FROM (
      SELECT geo.mlra_name, dh."PrimaryKey", geo.mlrarsym
      FROM public.mlra_v42_wgs84 as geo 
      JOIN %I."dataHeader" as dh 
      ON public.ST_WITHIN(dh.wkb_geometry, geo.geom)
   ) as src
   WHERE target."PrimaryKey" = src."PrimaryKey";', target_schema, target_schema
  );
  RETURN TRUE;
  ELSE
   RETURN FALSE;
 END IF;
END
$BODY$;

CREATE OR REPLACE FUNCTION public_test.postingest_populate_mlrarsym(
	_schema_name text)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
      FROM public.mlra_v42_wgs84 as geo 
      JOIN %I."dataHeader" as dh 
      ON public.ST_WITHIN(dh.wkb_geometry, geo.geom)
   ) as src
   WHERE target."PrimaryKey" = src."PrimaryKey";', target_schema, target_schema
  );
  RETURN TRUE;
  ELSE
   RETURN FALSE;
 END IF;
END
$BODY$;

CREATE OR REPLACE FUNCTION public_test.postingest_populate_state(
	_schema_name text)
    RETURNS boolean
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE PARALLEL UNSAFE
AS $BODY$
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
            AND column_name = ''State'')', target_schema) 
	INTO field_exists;
 IF field_exists IS TRUE
 THEN
  EXECUTE format('
    UPDATE %I."geoIndicators" as target
      SET "State" = src.stusps 
      FROM (
          SELECT geo.stusps, dh."PrimaryKey"
          FROM public.tl_2017_us_state_wgs84 as geo 
          JOIN %I."dataHeader" as dh 
          ON public.ST_WITHIN(dh.wkb_geometry, geo.geom)
      ) as src
      WHERE target."PrimaryKey" = src."PrimaryKey";', target_schema, target_schema
  );
  RETURN TRUE;
  ELSE
   RETURN FALSE;
 END IF;
END
$BODY$;


CREATE OR REPLACE PROCEDURE public_test.postingest_populate_fields(
	IN _schema_name text,
	IN _date text)
LANGUAGE 'plpgsql'
AS $BODY$
BEGIN
  PERFORM public_test.postingest_populate_mlra_name(_schema_name);
  PERFORM public_test.postingest_populate_mlrarsym(_schema_name);
  PERFORM public_test.postingest_populate_state(_schema_name);
  PERFORM public_test.postingest_populate_ecoregion(_schema_name);
  PERFORM public_test.postingest_populate_landcover(_schema_name, _date);
END;
$BODY$;
