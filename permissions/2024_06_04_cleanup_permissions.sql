-- single permission remove from all tables
call public_test.util_dynamic_permission_remove_alltables('public_test', 'blm_get', 'blm');
call public_test.util_dynamic_permission_remove_alltables('public_test', 'ndow_get', 'ndow');
call public_test.util_dynamic_permission_remove_alltables('public_test', 'nwern_get', 'nwern');

-- two permission remove from all tables

call public_test.util_dynamic_permission_remove_alltables('public_test', 'ndow_blm_get', 'blm');
call public_test.util_dynamic_permission_remove_alltables('public_test', 'blm_nwern_get', 'blm');
call public_test.util_dynamic_permission_remove_alltables('public_test', 'ndow_nwern_get', 'ndow');

-- three permission remove from all tables
call public_test.util_dynamic_permission_remove_alltables('public_test', 'ndow_blm_nwern_get', 'blm');

-- REPEATE WITH PUBLIC_DEV


-- RE ADD ALL PERMISSIONS 
/*
for users: durp_get, 
*/

-- single permissions add
call public_test.util_dynamic_createallow_alltables('public_test', 'blm_get', '{blm}')
call public_test.util_dynamic_createallow_alltables('public_test', 'durp_get', '{durp}')
call public_test.util_dynamic_createallow_alltables('public_test', 'nwern_get', '{nwern}')

-- two permissions 
call public_test.util_dynamic_createallow_alltables('public_test', 'durp_nwern_get', '{durp,nwern}')
call public_test.util_dynamic_createallow_alltables('public_test', 'durp_blm_get', '{durp, blm}')
call public_test.util_dynamic_createallow_alltables('public_test', 'blm_nwern_get', '{blm, nwern}')

--three permissions add

call public_test.util_dynamic_createallow_alltables('public_test', 'durp_blm_nwer_get', '{blm, durp, nwern}')