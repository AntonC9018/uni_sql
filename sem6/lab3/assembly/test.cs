using System;
using Microsoft.SqlServer.Server;
using System.Transactions;
using System.Data.SqlClient;

public static class Test
{
    // [SqlTrigger()]
    // [Microsoft.SqlServer.Server.SqlFunction(DataAccess = DataAccessKind.Read)]
    public static void Stuff()
    {
        var pipe = SqlContext.Pipe;
        pipe.Send("Hello");

        Rollback();

        var triggerContext = SqlContext.TriggerContext;
        if (triggerContext is null)
        {
            pipe.Send("The method has been called with a null trigger context." + Environment.NewLine);
            return;
        }
    }

    internal static void Rollback()
    {
        // https://docs.microsoft.com/en-us/sql/relational-databases/clr-integration-data-access-transactions/accessing-the-current-transaction?view=sql-server-ver15
        using (var transactionScope = new TransactionScope(TransactionScopeOption.Required)) { }
    }
}