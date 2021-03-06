declare
    v_animal Animal_Type := null; 
    v_fish   Fish_Type   := null;
    v_bear   Bear_Type   := null;

    procedure test_proc(arg Animal_Type)
        is begin
            dbms_output.put_line('Animal');
        end; 
    
    procedure test_proc(arg Bear_Type)
        is begin
            dbms_output.put_line('Bear');
        end; 
begin
    test_proc(v_animal);
    test_proc(v_fish);
    test_proc(v_bear);
end;