using System;
using Microsoft.SqlServer.Server;

public class Test
{
    public static void Stuff()
    {
        SqlContext.Pipe.Send("test" + Environment.NewLine);
    }
}