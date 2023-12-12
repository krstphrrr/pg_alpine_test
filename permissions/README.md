## functions for the dynamic assignment of RLS permissions 

# createallow_NND_singletable: 

- args: schema name, table name, role name
- return: no return
- description: provides NDOW, NWERN, BLM permissions to a role for *a given table* inside a given schema

# createallow_NND_alltables:

- args: schema name, role name
- return: no return
- description: provides NDOW, NWERN, BLM permissions to a role for *all tables* inside a given schema

# createallow_dynamic_singletable:

- args: schema name, table name, role name, array of permissions( ex: `sql {'ndow', 'nwern'}`)
- return: no return
- description: provides NDOW, NWERN *or* BLM permissions to a role for *a given table* inside a given schema

# createallow_dynamic_alltables:

- args: schema name, role name, array of permissions( ex: `sql {'ndow', 'nwern'}`)
- return: no return
- description: provides NDOW, NWERN *or*  BLM permissions to a role for *all tables* inside a given schema