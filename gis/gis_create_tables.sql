-- migrations of gis tables; changed location of postgis install from gis to public
-- modis_classes, eco_level4(ecoregion), mlra_v42, alaska ecoregion 
CREATE TABLE IF NOT EXISTS public.modis_classes
(
    index bigint,
    "Value" bigint,
    "Name" text COLLATE pg_catalog."default"
)

CREATE SEQUENCE IF NOT EXISTS public.us_eco_level_4_gid_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;
	
CREATE TABLE IF NOT EXISTS public.us_eco_level_4
(
    gid integer NOT NULL DEFAULT nextval('public.us_eco_level_4_gid_seq'::regclass),
    objectid double precision,
    us_l4code character varying(10) COLLATE pg_catalog."default",
    us_l4name character varying(100) COLLATE pg_catalog."default",
    us_l3code character varying(10) COLLATE pg_catalog."default",
    us_l3name character varying(100) COLLATE pg_catalog."default",
    na_l3code character varying(20) COLLATE pg_catalog."default",
    na_l3name character varying(100) COLLATE pg_catalog."default",
    na_l2code character varying(20) COLLATE pg_catalog."default",
    na_l2name character varying(100) COLLATE pg_catalog."default",
    na_l1code character varying(20) COLLATE pg_catalog."default",
    na_l1name character varying(100) COLLATE pg_catalog."default",
    l4_key character varying(125) COLLATE pg_catalog."default",
    l3_key character varying(125) COLLATE pg_catalog."default",
    l2_key character varying(125) COLLATE pg_catalog."default",
    l1_key character varying(125) COLLATE pg_catalog."default",
    shape_leng numeric,
    shape_le_1 numeric,
    shape_area numeric,
    geom geometry(MultiPolygon,4326),
    CONSTRAINT us_eco_level_4_pkey PRIMARY KEY (gid)
);

CREATE SEQUENCE IF NOT EXISTS gis.mlra_v42_wgs84_gid_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 2147483647
    CACHE 1;

CREATE TABLE IF NOT EXISTS public.mlra_v42_wgs84
(
    gid integer NOT NULL DEFAULT nextval('public.mlra_v42_wgs84_gid_seq'::regclass),
    mlrarsym character varying(4) COLLATE pg_catalog."default",
    mlra_id bigint,
    mlra_name character varying(200) COLLATE pg_catalog."default",
    lrrsym character varying(2) COLLATE pg_catalog."default",
    lrr_name character varying(135) COLLATE pg_catalog."default",
    geom geometry(MultiPolygon,4326),
    CONSTRAINT mlra_v42_wgs84_pkey PRIMARY KEY (gid)
);


CREATE TABLE IF NOT EXISTS public.mlra_2022
(
    ogc_fid integer NOT NULL DEFAULT nextval('mlra_2022_ogc_fid_seq'::regclass),
    mlra_id numeric(10,0),
    mlrarsym character varying(5) COLLATE pg_catalog."default",
    mlra_name character varying(254) COLLATE pg_catalog."default",
    lrrsym character varying(254) COLLATE pg_catalog."default",
    lrr_name character varying(254) COLLATE pg_catalog."default",
    wkb_geometry geometry(MultiPolygon,4326),
    CONSTRAINT mlra_2022_pkey PRIMARY KEY (ogc_fid)
)

CREATE TABLE IF NOT EXISTS public.ak_ecoregions
(
    gid integer NOT NULL DEFAULT nextval('gis.ak_ecoregions_gid_seq'::regclass),
    objectid double precision,
    us_l3code character varying(10) COLLATE pg_catalog."default",
    us_l3name character varying(100) COLLATE pg_catalog."default",
    na_l3code character varying(20) COLLATE pg_catalog."default",
    na_l3name character varying(100) COLLATE pg_catalog."default",
    na_l2code character varying(20) COLLATE pg_catalog."default",
    na_l2name character varying(100) COLLATE pg_catalog."default",
    na_l1code character varying(20) COLLATE pg_catalog."default",
    na_l1name character varying(100) COLLATE pg_catalog."default",
    state_name character varying(25) COLLATE pg_catalog."default",
    epa_region integer,
    l3_key character varying(254) COLLATE pg_catalog."default",
    na_l3key character varying(125) COLLATE pg_catalog."default",
    na_l2key character varying(125) COLLATE pg_catalog."default",
    na_l1key character varying(125) COLLATE pg_catalog."default",
    shape_leng numeric,
    shape_le_1 numeric,
    shape_area numeric,
    geom geometry(MultiPolygon,4326),
    CONSTRAINT ak_ecoregions_pkey PRIMARY KEY (gid)
)