using System.Collections;
using System.Reflection;
using System.Text;

public static class GenericXmlSerialization
{
    public static void Log(string s)
    {
        // SqlContext.Pipe.Send(s + Environment.NewLine);
    }

    public static string SerializeXml<T>(this T obj)
    {
        var builder = new StringBuilder();
        SerializeXmlInternal(builder, obj, 0);
        return builder.ToString();
    }

    private static void SerializeXmlInternal(StringBuilder builder, object obj, int indentation)
    {
        if (obj is null)
        {
            builder.Append("null");
            return;
        }

        var type = obj.GetType();
        if (type == typeof(string))
        {
            builder.Append('"');
            builder.Append(obj as string);
            builder.Append('"');
            return;
        }
        // else 

        if (type.IsArray)
        {
            builder.Append("Array. Actual type: ");
            builder.Append(type.FullName);
            return;
        }

        if (typeof(DictionaryBase).IsAssignableFrom(type))
        {
            builder.Append("Some sort of Dictionary. Actual type: ");
            builder.Append(type.FullName);
            return;
        }

        if (typeof(System.Collections.IEnumerable).IsAssignableFrom(type))
        {
            builder.Append("Collection. Actual type: ");
            builder.Append(type.FullName);
            return;
        }

        if (type.IsPrimitive)
        {
            builder.Append(obj.ToString());
            return;
        }

        builder.Append("{");

        indentation += 4;

        var fields = type.GetFields(
            BindingFlags.Instance
            | BindingFlags.NonPublic
            | BindingFlags.Public);
            
        for (int i = 0; i < fields.Length; i++)
        {
            object obj2 = null;
            bool threw = false;
            try
            {
                obj2 = fields[i].GetValue(obj);
            }
            catch (System.FieldAccessException)
            {
                threw = true;
            }

            AppendLineAndIndentation(builder, indentation);

            builder.Append(fields[i].Name);
            builder.Append(": ");
            if (threw)
                builder.Append("error");
            else
                SerializeXmlInternal(builder, obj2, indentation);

            if (i != fields.Length - 1)
                builder.Append(",\n");
        }

        if (fields.Length > 0)
            AppendLineAndIndentation(builder, indentation);
        builder.Append("}");
    }
    
    static void AppendLineAndIndentation(StringBuilder builder, int indentation)
    {
        builder.Append('\n');
        for (int j = 0; j < indentation; j++)
            builder.Append(' ');
    }
}