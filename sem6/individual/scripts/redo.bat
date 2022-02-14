dmd -i -m64 generate_data.d
generate_data
sqlcmd -i clear.sql
sqlcmd -i tables.sql
sqlcmd -i add_things.sql