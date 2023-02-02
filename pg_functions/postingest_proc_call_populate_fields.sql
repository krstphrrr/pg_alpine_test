
CREATE OR REPLACE PROCEDURE public_test.populate_fields()
 LANGUAGE sql
AS $procedure$
  CALL public_test.postingest_populate_mlra_name('public_test');
  CALL public_test.postingest_populate_mlrarsym('public_test');
  CALL public_test.postingest_populate_state('public_test');
  CALL public_test.postingest_populate_ecoregion('public_test');
  CALL public_test.postingest_populate_landcover();
$procedure$
