
import std.stdio;
import std.array;
import core.time;
import std.datetime;
import std.typecons;

const schemaName = "Scoala";
const schoolCreationDate = Date(2000, 1, 2);

///
enum PrimaryKey;


enum FKFlags
{
    /// May refer to more than one thing from the other table.
    allowMultiple,
    /// Must exhaust all references in the foreign table.
    exhaustAllReferences,
}

/// 
template ForeignKey(T, FKFlags f)
{ 
    alias Type = T;
    enum flags = f;
}

/// Generate the random number in the given range.
struct Range(T) { T from; T to; }

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
enum LastName = UsePool("LastName");
///
enum Name = UsePool("Name");
///
enum PositionName = UsePool("PositionName");

/// Fill with random nonsense
enum Lorem = UsePool("Lorem");

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

string[] readLorem()
{
    import std.string : strip;
    return File("../data/lorem.txt")
        .byLineCopy()
        .filter!(a => a != "")
        .map!(a => strip(a))
        .array;
}

void main()
{
    auto b = appender!string;

    auto pools = [
        "Name": readNames(),
        "LastName": readLastNames(),
        "Lorem": readLorem(),
    ];

    import std.meta;
    import std.traits;

    alias Types = AliasSeq!(
        Student,
        Angajat,
        Functie,
        AngajatFunctie,
        AngajatCualificatieInfo,
        Obiect,
        Clasa,
        ProfesorObiect,
        ClasaStudent,
        ClasaObiect,
        Nota,
        Cheltuieli);

    static foreach (Type; Types)
    {

    }
}

@GenerateCount(600)
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
@(ForeignKey!(Functie, FKFlags.allowMultiple))
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
struct AngajatCualificatieInfo
{
      id         int not null identity(1, 1),
    angajat_id int not null,

    -- Orice informatii, nerelevant pentru baze de date.
    textual_description nvarchar(max) not null,

    constraint AngajatCualificatieInfo_PK
    primary key (id),

    constraint AngajatCualificatieInfo_FK_angajat
    foreign key (angajat_id)
    references Scoala.Angajat (id)
}


create table Scoala.Obiect(
    id   int not null identity(1, 1),
    nume nvarchar(128) not null,

    -- TODO: ensure it's sorted along with id, I don't know how.
    semestru_de_prima_aparitie_offset smallint not null,
    
    -- Probabil in viata reala vom avea nevoie de mai multe date aici, ca la ce an de studii
    --  se corespunde obiectul, poate trebuie sa diferentiem obiecte si cursuri, etc.
    -- prim_an_de_studii_posibil tinyint,

    constraint Obiect_PK
    primary key (id),
);