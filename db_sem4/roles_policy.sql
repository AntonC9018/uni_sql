create or replace function auth_clients( 
    schema_var in varchar2,
    table_var  in varchar2
)
    return varchar2
    is
        v_role varchar2(20);
    begin

        v_role := SYS_CONTEXT('user_roles_context', 'user_role');

        if (v_role = 'CLIENT_ROLE') then
            return 'UPPER(FIRST_NAME) = ''' || SYS_CONTEXT('USERENV', 'SESSION_USER') || '''';
        end if;

        return '1=1';

    end auth_clients;
/
begin
    dbms_rls.drop_policy(
        object_schema   => 'birou', 
        object_name     => 'client_table', 
        policy_name     => 'select_client_policy'
    );

    dbms_rls.add_policy(
        object_schema   => 'birou', 
        object_name     => 'client_table', 
        policy_name     => 'select_client_policy', 
        function_schema => 'sec_admin',
        policy_function => 'auth_clients', 
        statement_types => 'select'
    );
end;
/



create or replace function auth_transaction( 
    schema_var in varchar2,
    table_var  in varchar2
)
    return varchar2
    is
        v_role varchar2(20);
    begin

        v_role := SYS_CONTEXT('user_roles_context', 'user_role');

        if (v_role = 'CLIENT_ROLE') then
            return 'UPPER(DEREF(TRANSACTION_TABLE.CLIENT).FIRST_NAME) = ''' || SYS_CONTEXT('USERENV', 'SESSION_USER') || '''';
        end if;

        return '1=1';

    end auth_transaction;
/
begin
    dbms_rls.drop_policy(
        object_schema   => 'birou', 
        object_name     => 'transaction_table', 
        policy_name     => 'select_transaction_policy'
    );

    dbms_rls.add_policy(
        object_schema   => 'birou', 
        object_name     => 'transaction_table', 
        policy_name     => 'select_transaction_policy', 
        function_schema => 'sec_admin',
        policy_function => 'auth_transaction', 
        statement_types => 'select'
    );
end;
/