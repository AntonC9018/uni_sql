using System;
using System.Data.SqlClient;
using Microsoft.SqlServer.Server;

public class Test
{
    // [SqlTrigger(Name = @"UsersAudit", Target = "[dbo].[users]", Event = "FOR INSERT")]
    public static void Stuff()
    {
        if (SqlContext.TriggerContext is null)
        {
            SqlContext.Pipe.Send("The method has been called with a null trigger context." + Environment.NewLine);
            return;
        }

        var triggerContext = SqlContext.TriggerContext;

        switch (triggerContext.TriggerAction)
        {
            case TriggerAction.Insert:
            {
                    // Retrieve the connection that the trigger is using.
                using (var connection = new SqlConnection(@"context connection=true"))
                {
                    connection.Open();

                    // Get the inserted row.
                    var command = new SqlCommand(@"select * from inserted;", connection);

                    // Get the user name and real name of the inserted user.
                    var reader = command.ExecuteReader();
                    reader.Read();
                    var userName = (string) reader[0];
                    var realName = (string) reader[1];
                    reader.Close();

                    // Insert the user name and real name into the auditing table.
                    var command2 = new SqlCommand(@"
                        insert [dbo].[CurmanschiiAnton_InsertAudit] (userName, realName)
                        values (@userName, @realName);", connection);

                    command.Parameters.Add(new SqlParameter("@userName", userName));
                    command.Parameters.Add(new SqlParameter("@realName", realName));

                    command.ExecuteNonQuery();
                }
                break;
            }
            
            case TriggerAction.Update:
            {
                break;
            }
            
            case TriggerAction.Delete:
            {
                break;
            }
        }

    }
}