using System;
using Microsoft.SqlServer.Server;

public class HelloWorldProc
{
    [SqlProcedure]
    public static void HelloWorld(out string text)
    {
        SqlContext.Pipe.Send("Hello world!" + Environment.NewLine);
        text = "Hello world!";
    }
}