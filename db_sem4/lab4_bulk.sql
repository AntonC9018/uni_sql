drop type Transaction_Table_Type force;
/
create type Transaction_Table_Type as table of Transaction_Type;
/

/* QUERIES. RUN SEPARATELY */

declare
    v_transactions Transaction_Table_Type;
    
    -- Cursorul explicit este necesar pentru a stabili limita de 3
    cursor transaction_cursor is 
        select value(t)
        from Transaction_Table t;
begin
    open transaction_cursor;

    -- Utilizarea lui bulk collect
    fetch transaction_cursor 
    bulk collect into v_transactions
    limit 3;

    -- Afisam valorile comisiei
    for i in v_transactions.first .. v_transactions.last
    loop
        dbms_output.put_line(v_transactions(i).comission);
    end loop;

    -- Incrementam comisia cu 100 la fiecare tranzactie
    forall i in v_transactions.first .. v_transactions.last
    update Transaction_Table t 
        set t.comission = t.comission + 100 
        where t.id = v_transactions(i).id;

    commit;

    close transaction_cursor;
end;