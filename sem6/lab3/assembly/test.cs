using System;
using Microsoft.SqlServer.Server;
using System.Transactions;
using System.Data.SqlClient;
using System.Xml.Linq;
using System.Linq;
using System.Text;

public static class Test
{
    public static void Stuff()
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

            var actions = (document.FirstNode as XElement)
                .Elements("AlterTableActionList")
                .First()
                .Elements();
            
            // For some reason XName is a class, so this allocates.
            XName Name = "Name";
            bool hasRolledBack = false;

            foreach (var action in actions)
            {
                var columns = action.Elements("Columns");

                const string protectedColumnName = "credits";
                if (action.Name.LocalName == "Drop" 
                    || action.Name.LocalName == "Alter")
                {
                    if (columns
                        .SelectMany(col => col.Elements(Name))
                        .Any(name => name.Value.Equals(
                            protectedColumnName, StringComparison.CurrentCultureIgnoreCase)))
                    {
                        pipe.Send($"The column `{protectedColumnName}` cannot be modified.");

                        if (!hasRolledBack)
                        {
                            Rollback();
                            hasRolledBack = true;
                        }
                    }
                }
                else if (action.Name.LocalName == "Create")
                {
                    var sb = new StringBuilder("Adding: ");
                    var lb = new ListBuilder(sb, ", "); 
                    var constraints = action.Elements("Constraints");
                    var names = columns
                        .Concat(constraints)
                        .SelectMany(c => c.Elements(Name))
                        .Select(a => a.Value);

                    foreach (var name in names)
                        lb.AppendItem(name);

                    // Debug asserting here is a good idea, actually, but whatever.
                    if (lb.HasAppended)
                    {
                        sb.Append(".");
                        pipe.Send(sb.ToString());
                    }
                }
            }
        }
    }

    internal static void Rollback()
    {
        // https://docs.microsoft.com/en-us/sql/relational-databases/clr-integration-data-access-transactions/accessing-the-current-transaction?view=sql-server-ver15
        using (var transactionScope = new TransactionScope(TransactionScopeOption.Required)) { }
    }

    internal struct ListBuilder
    {
        public StringBuilder _sb;
        public string _separator;
        public bool _hasAppended;

        public bool HasAppended => _hasAppended;

        public ListBuilder(StringBuilder sb, string separator)
        {
            _sb = sb;
            _separator = separator;
            _hasAppended = false;
        }

        public void AppendItem(string str)
        {
            if (_hasAppended)
                _sb.Append(_separator);
            _sb.Append(str);
            _hasAppended = true;
        }
    }
}