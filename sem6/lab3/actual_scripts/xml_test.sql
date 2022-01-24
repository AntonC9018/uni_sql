create or alter procedure Test
as
begin
    declare @string nvarchar(max) = N'<EVENT_INSTANCE>
  <AlterTableActionList>
    <Drop>
      <Columns>
        <Name>credits</Name>
      </Columns>
    </Drop>
  </AlterTableActionList>
</EVENT_INSTANCE>';
    declare @xml xml = cast(@string as xml);

	declare @action_list xml = @xml.nodes('EVENT_INSTANCE/AlterTableActionList');

    
end
go

exec Test