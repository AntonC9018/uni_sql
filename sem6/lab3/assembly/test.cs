using System;
using Microsoft.SqlServer.Server;
using System.Transactions;
using System.Data.SqlClient;

public static class Test
{
    [Microsoft.SqlServer.Server.SqlFunction(DataAccess = DataAccessKind.Read)]
    public static bool Stuff()
    {
        var pipe = SqlContext.Pipe;
        pipe?.Send("Hello");

        if (SqlContext.TriggerContext is null)
        {
            pipe?.Send("The method has been called with a null trigger context." + Environment.NewLine);
            return true;
        }


        // using (var connection = CreateContextConnection())
        // {
        //     connection.Open();
        //     using (var transaction = connection.BeginTransaction())
        //     {
        //         SqlContext.Pipe.Send("Hello 2");
        //         transaction.Rollback();
        //         SqlContext.Pipe.Send("Hello 3");
        //     }
        // }
        
        return false;
        // Transaction.Current?.Rollback();
        // var triggerContext = SqlContext.TriggerContext;
        // SqlContext.Pipe.Send(triggerContext.EventData.ToString());
    }

    public static SqlConnection CreateContextConnection()
    {
        return new SqlConnection("context connection=true");
    }
}