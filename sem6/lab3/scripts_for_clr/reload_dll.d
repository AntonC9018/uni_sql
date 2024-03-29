import std.stdio;
import std.path;
import std.process;
import std.string;

// Just compile it with `dmd reload_dll.d`

struct Options
{
    @("Whether to call `dotnet build` before refreshing. Default is `true`")
    bool shouldRecompile = true;

    @("The name of the database that contains the given assembly. `master` by default.")
    string assemblyDatabaseName = "master";

    @("The assembly name (the name of the object in the database). `TestProject` by default.")
    string assemblyObjectName = "TestProject";

    @("The instance of the server to execute the command at. Autodetected by default.")
    string serverName = null;

    @("The relative or absolute path to the project folder.")
    string pathToProjectDirectory = `..\assembly`;

    @("The path to the dll, either relative to the project folder, or absolute.")
    string pathToCompiledAssembly = `bin\Debug\net461\Test.dll`;
}

void main(string[] args)
{
    Options op;
    import std.getopt;
    auto helpInformation = getOptions(args, op);
    if (helpInformation.helpWanted)
    {
        const help = `Refreshes the dotnet code in the database.`;
        defaultGetoptPrinter(help, helpInformation.options);
        return;
    }

    reload(op);
}

bool reload(in Options options)
{
    if (options.shouldRecompile)
    {
        const result = execute(["dotnet", "build", options.pathToProjectDirectory]);
        if (result.status != 0)
        {
            writeln("Executing build failed: ");
            writeln(result.output);
            return false;
        }
    }

    static string getServerName()
    {
        const getServersCommand = `sqlcmd -Q "exec sp_helpserver"`;
        const result = executeShell(getServersCommand);
        if (result.status != 0)
        {
            writeln("Executing build failed: ");
            writeln(result.output);
            return null;
        }

        // the query has the format
        
        // header_names
        // -----------
        // values

        // the name column is the first one.
        // so the third line contains that name.

        const thirdLine = result.output.split("\n")[2];
        const serverNameEndIndex = thirdLine.indexOf(' ');
        const serverName = thirdLine[0 .. serverNameEndIndex];
        return serverName;
    }

    string serverName = options.serverName;
    if (serverName == null)
    {
        serverName = getServerName();
        if (serverName == null)
            return false;
    }

    const assemblyName         = options.assemblyObjectName;
    const assemblyDatabaseName = options.assemblyDatabaseName;
    const assemblyPath         = (){
        if (isAbsolute(options.pathToCompiledAssembly))
            return options.pathToCompiledAssembly;
        return absolutePath(options.pathToProjectDirectory)
            .buildPath(options.pathToCompiledAssembly);
    }();

    import std.file : isFile;
    if (!isFile(assemblyPath))
    {
        writeln("The assembly at ", assemblyPath, " is not a file.");
        return false;
    }

    const refreshProjectSqlString = format(`
        use %s
        go
        alter assembly %s from '%s'
        go`, assemblyDatabaseName, assemblyName, assemblyPath);
    writeln("Executing: ", refreshProjectSqlString);

    // I'm not sure if the server name is required btw.
    const sqlResult = execute(["sqlcmd", "-S", serverName, "-Q", refreshProjectSqlString]);
    
    writeln(sqlResult.output);

    return sqlResult.status == 0;
}


auto getOptions(T)(string[] args, out T op)
{
    import std.getopt;
    return mixin((){
        auto ret = "getopt(args";
        static foreach (field; T.tupleof)
        {
            import std.format;
            ret ~= `, "%s", "%s", &op.%1$s`.format(__traits(identifier, field), __traits(getAttributes, field)[0]);
        }
        ret ~= ")";
        return ret;
    }());
}
