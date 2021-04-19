create or replace package User_Roles_Context_Package
    is 
    procedure set_user_role;
end;
/
create or replace package body User_Roles_Context_Package 
    is
    procedure set_user_role
        is
            user_role varchar2(20);
        begin
            select GRANTED_ROLE 
                into user_role
                from dba_role_privs       
                where grantee = SYS_CONTEXT('USERENV', 'SESSION_USER')
                and GRANTED_ROLE in ('CLIENT_ROLE', 'NOTAR_ROLE', 'SEF_ROLE');
            dbms_session.set_context('user_roles_context', 'user_role', user_role);
        exception  
            when no_data_found then null;
    end;
end;
/
create or replace context user_roles_context using User_Roles_Context_Package;
/
create or replace trigger User_Roles_Context_Trigger after logon on database
    begin
        sec_admin.User_Roles_Context_Package.set_user_role;
    end;
/