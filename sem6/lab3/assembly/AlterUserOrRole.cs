using System;
using Microsoft.SqlServer.Server;
using System.Transactions;
using System.Data.SqlClient;
using System.Xml.Linq;
using System.Linq;
using System.Text;

public static class AlterUserOrRole
{
    public static void TriggerFunctionAdded()
    {
        TriggerFunction(whetherAdded: true);
    }
    
    public static void TriggerFunctionDropped()
    {
        TriggerFunction(whetherAdded: false);
    }

    public static void TriggerFunction(bool whetherAdded)
    {
        var pipe = SqlContext.Pipe;

        var triggerContext = SqlContext.TriggerContext;
        if (triggerContext is null)
        {
            pipe.Send("The method has been called with a null trigger context.");
            return;
        }

        using (var reader = triggerContext.EventData.CreateReader())
        {
            var document = XDocument.Load(reader);
            var firstElement = document.FirstNode as XElement;

            if (firstElement.Element("ObjectType").Value != "SQL USER")
                return;

            var commandText = firstElement
                .Element("TSQLCommand")
                .Element("CommandText")
                .Value;
            
            var roleName = firstElement
                .Element("RoleName")
                .Value;

            var affectedUserName = firstElement
                .Element("ObjectName")
                .Value;

            using (var connection = new SqlConnection("context connection=true"))   
            {  
                connection.Open();

                {
                    var command = connection.CreateCommand();
                    const string insertQueryString = @"
                        insert into DDLTriggers_TestSchema.PrivilegeAltered_AuditTable (
                                login_name,
                                user_name,
                                the_statement,
                                role_name,
                                was_added)
                            values (
                                ORIGINAL_LOGIN(),"
                                + "@" + nameof(affectedUserName) + ","
                                + "@" + nameof(commandText)      + ","
                                + "@" + nameof(roleName)         + ","
                                + "@" + nameof(whetherAdded)     + ")";
                    command.CommandText = insertQueryString;

                    var ps = command.Parameters; 
                    ps.AddWithValue("@" + nameof(affectedUserName), affectedUserName);
                    ps.AddWithValue("@" + nameof(commandText),      commandText);
                    ps.AddWithValue("@" + nameof(roleName),         roleName);
                    ps.AddWithValue("@" + nameof(whetherAdded),     whetherAdded);

                    int numberOrRowAdded = command.ExecuteNonQuery();

                    pipe.Send($"Added {numberOrRowAdded} rows");
                }
            }
        }
    }
}