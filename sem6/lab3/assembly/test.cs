using System;
using Microsoft.SqlServer.Server;

public class Test
{
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