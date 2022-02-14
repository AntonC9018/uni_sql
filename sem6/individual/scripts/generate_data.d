module generate_data;

import std.stdio;
import std.array;
import core.time;
import std.datetime;
import std.typecons;

enum schemaName = "Scoala";
enum schoolCreationDate = Date(2000, 1, 2);

///
enum PrimaryKey;


enum FKFlags
{
    none = 0,
    /// May refer to more than one thing from the other table.
    allowMultiple = 1,
    /// Must exhaust all references in the foreign table.
    exhaustAllReferences = 2,
    /// Force unique
    // allowMultiple = 4
}

/// 
// struct ForeignKey(T, FKFlags f = FKFlags.none){}
struct ForeignKey(T, FKFlags f = FKFlags.none);

/// Generate the random number in the given range.
struct Range(T) { T from; T to; }

///
alias IntRange = Range!int;
///
alias DateRange = Range!Date;

/// 
struct SmallMoney { int amount; }
///
alias SmallMoneyRange = Range!SmallMoney;

/// Must be greater than another fields from the same struct with the given name.
struct MoreThan { string fieldName; }

/// The chance of rolling null.
/// Only applicable to nullables.
struct NullChance { float chance; }

/// The chance of rolling true.
/// Only applicable to bools.
struct TrueChance { float chance; }

/// Which pool to use. Must be present at runtime in the mapper
struct UsePool { string name; }

/// 
struct GenerateCount { int count; }



import std.csv;
import std.algorithm;
import std.range;

string[] readNames()
{
    auto readOneFile(string filename)
    {
        import std.string;
        enum FirstForenameIndex = 2;
        return File(filename)
            .byLine()
            .drop(1)
            .map!(a => strip(a))
            .take(150)
            .joiner("\n")
            .csvReader!(string, Malformed.ignore)
            .map!(a => a.drop(FirstForenameIndex).front);
    }

    return chain(
            readOneFile("../data/babies-first-names-top-100-boys.csv"),
            readOneFile("../data/babies-first-names-top-100-girls.csv"))
        .array;
}

string[] readLastNames()
{
    import std.string;
    return File("../data/surnames.csv")
        .byLine()
        .drop(1)
        .map!(a => strip(a))
        .joiner("\n")
        .csvReader!(string, Malformed.ignore)
        .map!(a => a.front[0] ~ a.front[1 .. $].toLower)
        .array;
}

// string stripCarriageReturn(string a)
// {
//     return a[$ - 1] == '\r' ? a[0 .. $ - 1]

string[] readTxtNonEmpty(string filename)
{
    import std.string : strip;
    return File(filename)
        .byLineCopy()
        .filter!(a => a != "")
        .map!(a => strip(a))
        .array;
}

///
enum LastName = UsePool("LastName");
///
enum Name = UsePool("Name");
///
enum PositionName = UsePool("PositionName");

/// Fill with random nonsense
enum Lorem = UsePool("Lorem");

///
enum Subjects = UsePool("Subject");


import std.meta;
import std.traits;

template ValidTypes(Modules...)
{
    alias result = AliasSeq!();
    static foreach (Module; Modules)
    {
        static foreach (typeName; __traits(allMembers, Module))
        {
            static if (hasUDA!(__traits(getMember, Module, typeName), GenerateCount))
            {
                result = AliasSeq!(result, __traits(getMember, Module, typeName));
            }
        }
    }
    alias ValidTypes = result;
}


void main()
{
    auto pools = [
        "Name": readNames(),
        "LastName": readLastNames(),
        "Lorem": readTxtNonEmpty("../data/lorem.txt"),
        "Subject": readTxtNonEmpty("../data/subjects.txt"),
        "PositionName": readTxtNonEmpty("../data/job_names.txt"),
    ];
    alias Types = ValidTypes!(generate_data);

    template Data(Type)
    {
        enum count = getUDAs!(Type, GenerateCount)[0].count;
        Type[] array;
    }

    static foreach (Type; Types)
    {{
        Data!Type.array = new Type[](Data!Type.count);
        auto myArray = Data!Type.array;
        
        foreach (index, ref it; myArray)
        { 
            static foreach (field; Type.tupleof)
            {{
                import std.random;
                static foreach (uda; __traits(getAttributes, field))
                {
                    static if (is(typeof(uda) == UsePool))
                    {{
                        auto pool = pools[uda.name];
                        auto poolItemIndex = uniform!("[)", size_t)(0, pool.length);
                        __traits(getMember, it, __traits(identifier, field)) = pool[poolItemIndex];
                    }}
                    static if (is(typeof(uda) : Range!T, T))
                    {{
                        auto generateRng()
                        {
                            static if (is(T == Date))
                            {
                                auto difference = uda.to - uda.from;
                                auto days = uniform!("[]")(0, difference.total!"days");
                                auto result = uda.from + dur!"days"(days);
                            }
                            else static if (is(T == SmallMoney))
                            {
                                auto amount = uniform!("[]")(uda.from.amount, uda.to.amount);
                                auto result = SmallMoney(amount);
                            }
                            else
                            {
                                auto result = uniform!("[]")(uda.from, uda.to);
                            }
                            return result;
                        }

                        auto result = generateRng();

                        // hax
                        static if (hasUDA!(field, MoreThan))
                        {{
                            size_t counter = 0;
                            while (result <= __traits(getMember, it, getUDAs!(field, MoreThan)[0].fieldName))
                            {
                                result = generateRng();
                                if (counter++ == 10000)
                                    assert(false, "Probably an infinite thing");
                            }
                        }}
                        static if (hasUDA!(field, NullChance))
                        {{
                            if (uniform!"[)"(0f, 1f) > getUDAs!(field, NullChance)[0].chance)
                                __traits(getMember, it, __traits(identifier, field)) = result;
                        }}
                        else
                            __traits(getMember, it, __traits(identifier, field)) = result;

                    }}
                    static if (is(typeof(uda) : TrueChance))
                    {{
                        __traits(getMember, it, __traits(identifier, field)) = uniform!"[)"(0f, 1f) < uda.chance;
                    }}
                }
            }}
        }
    }}

    template FKArrayInfo(Type, alias uda)
    {
        static if (is(uda == ForeignKey!(FType, f), FType, FKFlags f))
        {
            alias flags = f;
            alias ForeignType = FType;
            int[] array = new int[](Data!Type.count);
        }
        else 
            static assert(0);
    }

    template FKArrays(Type)
    {
        alias result = AliasSeq!();
        static foreach (uda; __traits(getAttributes, Type))
        {
            static if (__traits(compiles, FKArrayInfo!(Type, uda)))
            {
                result = AliasSeq!(result, FKArrayInfo!(Type, uda));
            }
        }
        alias FKArrays = result;
    }

    static foreach (Type; Types)
    {
        static foreach (info; FKArrays!Type)
        {{
            size_t countOfOtherThing = Data!(info.ForeignType).count;
            auto fkArr = info.array;

            static if (info.flags & FKFlags.exhaustAllReferences)
            {{
                size_t index = 0;
                foreach (ref it; fkArr)
                {
                    it = cast(int) index;
                    index++;
                    if (index == countOfOtherThing)
                        index = 0;
                }
            }}
            else
            {
                foreach (ref it; fkArr)
                {
                    import std.random;
                    it = uniform!("[)", int)(0, cast(int) countOfOtherThing);
                }
            }
        }}
    }

    auto b = appender!string;
    static foreach (Type; Types)
    {
        foreach (index; 0 .. Data!Type.count)
        {{
            b ~= "insert into " ~ schemaName ~ "." ~ Type.stringof ~ "(\n";
            import std.format;
            import std.string;
            
            {
                int appendCommandCountdown = cast(int) (FKArrays!Type.length + Type.tupleof.length);
                
                void appendWithComma(string str)
                {
                    b ~= "    " ~ str;
                    appendCommandCountdown--;
                    if (appendCommandCountdown > 0)
                        b ~= ",";
                    b ~= "\n";
                }

                static foreach (fkArr; FKArrays!Type)
                    appendWithComma("id_" ~ toLower(fkArr.ForeignType.stringof));
                static foreach (field; Type.tupleof)
                    appendWithComma(__traits(identifier, field));
                    
                b ~= ") values (\n";
            }
            {
                void appendT(T)(T value)
                {
                    static if (is(T == Date))
                    {
                        b.formattedWrite("cast('%d-%d-%d' as date)",
                            value.year, cast(int) value.month, value.day);
                    }
                    else static if (is(T == string))
                    {
                        b ~= "'";
                        b ~= value.replace("'", "''");
                        b ~= "'";
                    }
                    else static if (is(T == bool))
                    {
                        b ~= value ? "1" : "0";
                    }
                    else static if (is(T : Nullable!TT, TT))
                    {
                        if (value.isNull)
                            b ~= "null";
                        else
                            appendT!TT(value.get());
                    }
                    else static if (is(T : SmallMoney))
                    {
                        b.formattedWrite("%d", value.amount);
                    }
                    else
                    {
                        b.formattedWrite("%d", value);
                    }
                }

                int appendCommandCountdown0 = cast(int) (FKArrays!Type.length + Type.tupleof.length);

                void append(T)(T value)
                {
                    import std.conv : to;
                    b ~= "    ";

                    appendT(value);

                    appendCommandCountdown0--;
                    if (appendCommandCountdown0 > 0)
                        b ~= ",";
                    b ~= "\n";
                }
                
                static foreach (fkArr; FKArrays!Type)
                    append(fkArr.array[index]);
                static foreach (field; Type.tupleof)
                    append(__traits(child, Data!Type.array[index], field));

                b ~= ")";
                b ~= "\n";
            }
        }}
    }

    string outputFileName = "add_things.sql";
    auto file = File(outputFileName, "w");
    file.write(b[]);
    file.flush();
    file.close();
}

@GenerateCount(1000)
struct Student
{
    @DateRange(Date(1998, 1, 1), Date(2009, 1, 1))
    Date data_de_nastere;
    
    @Name
    string prenume;
    
    @LastName
    string nume;
}

@GenerateCount(25)
struct Angajat
{
    @DateRange(Date(1950, 1, 1), Date(1980, 1, 1))
    Date data_de_nastere;
    
    @Name
    string prenume;
    
    @LastName
    string nume;
}


@GenerateCount(35)
struct Functie
{
    @PositionName
    string nume;

    @Lorem
    string descriere;
    
    @TrueChance(0.25)
    bool profesorBit;
}


@GenerateCount(75)
@(ForeignKey!(Functie))
struct AngajatFunctie
{
    @DateRange(Date(2000, 1, 2), Date(2004, 1, 1))
    Date data_from;

    @SmallMoneyRange(SmallMoney(1000), SmallMoney(5000))
    SmallMoney salariu_pe_luna;
    
    @MoreThan("data_from")
    @NullChance(0.7f)
    @DateRange(Date(2000, 1, 2), Date(2020, 1, 1))
    Nullable!Date data_until;
}

@GenerateCount(50)
@(ForeignKey!Angajat)
struct AngajatCualificatieInfo
{
    @Lorem
    string textual_description;
}


@GenerateCount(25)
struct Obiect
{
    @Subjects
    string nume;

    @DateRange(Date(2000, 1, 2), Date(2010, 1, 1))
    Date semestru_de_prima_aparitie_offset;
}

@GenerateCount(100)
struct Clasa
{
    @IntRange(0, 22 * 2)
    int semestru_de_existenta_offset;

    @NullChance(1)
    Nullable!int predecesor_clasa_id;

    @IntRange(0, 23)
    int semestru_de_studii;

    @(Range!char('A', 'C'))
    char litera;
}

@GenerateCount(250)
@(ForeignKey!(Angajat))
@(ForeignKey!(Obiect))
@(ForeignKey!(Clasa, FKFlags.exhaustAllReferences))
struct ProfesorObiectClasa
{
}


// It will be a bit wrong, but who cares
@GenerateCount(250)
@(ForeignKey!(Clasa, FKFlags.exhaustAllReferences))
@(ForeignKey!(Student, FKFlags.exhaustAllReferences))
struct ClasaStudent
{

}


@GenerateCount(15000)
@(ForeignKey!(Student, FKFlags.exhaustAllReferences))
@(ForeignKey!(Obiect, FKFlags.exhaustAllReferences))
@(ForeignKey!(Clasa, FKFlags.exhaustAllReferences))
struct Nota
{
    @(Range!ubyte(0, 75))
    ubyte numar_zi;

    @(Range!ubyte(0, 9))
    ubyte valoarea;
}