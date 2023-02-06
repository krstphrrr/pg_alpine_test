
CREATE OR REPLACE PROCEDURE public_test.populate_fields()
 LANGUAGE sql
AS $procedure$
  PERFORM public_test.postingest_populate_mlra_name('public_test');
  PERFORM public_test.postingest_populate_mlrarsym('public_test');
  PERFORM public_test.postingest_populate_state('public_test');
  PERFORM public_test.postingest_populate_ecoregion('public_test');
  PERFORM public_test.postingest_populate_landcover();
$procedure$
