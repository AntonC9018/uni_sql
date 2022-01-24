using System;
using Microsoft.SqlServer.Server;
using System.Transactions;

public static class Test
{
    public static void Stuff()
    {
        SqlContext.Pipe.Send("Hello");
        Transaction.Current?.Rollback();

        if (SqlContext.TriggerContext is null)
        {
            SqlContext.Pipe.Send("The method has been called with a null trigger context." + Environment.NewLine);
            return;
        }

        var triggerContext = SqlContext.TriggerContext;
        SqlContext.Pipe.Send(triggerContext.EventData.ToString());
    }
}