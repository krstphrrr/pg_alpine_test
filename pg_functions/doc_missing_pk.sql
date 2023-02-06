CREATE OR REPLACE FUNCTION public_test.missing_pk(tablename text)
 RETURNS SETOF text[]
 LANGUAGE plpgsql
AS $function$
BEGIN
 RETURN QUERY EXECUTE '
        select array["PrimaryKey"::text] from public_test.' || quote_ident(tablename) || '
        test where not exists (
                select * from public_dev.' || quote_ident(tablename) || '
                dev where test."PrimaryKey" = dev."PrimaryKey")';
END
$function$
