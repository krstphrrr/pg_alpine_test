
CREATE OR REPLACE PROCEDURE public_test.populate_fields(_schema_name text)
 LANGUAGE plpgsql
AS $procedure$
BEGIN
  PERFORM public_test.postingest_populate_mlra_name(_schema_name);
  PERFORM public_test.postingest_populate_mlrarsym(_schema_name);
  PERFORM public_test.postingest_populate_state(_schema_name);
  PERFORM public_test.postingest_populate_ecoregion(_schema_name);
  PERFORM public_test.postingest_populate_landcover(_schema_name);
END;
$procedure$
