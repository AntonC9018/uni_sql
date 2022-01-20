using System;
using Microsoft.SqlServer.Server;
using System.Diagnostics;

public class Test
{
    public static void Stuff()
    {
        SqlContext.Pipe.Send("test" + Environment.NewLine);

        if (SqlContext.TriggerContext is null)
            return;

        var triggerContext = SqlContext.TriggerContext;

        switch (triggerContext.TriggerAction)
        {
            case TriggerAction.Insert:
            {
                SqlContext.Pipe.Send(triggerContext.EventData.Value);
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