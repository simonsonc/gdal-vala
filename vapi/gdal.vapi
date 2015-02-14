[CCode (cheader_filename = "gdal.h")]
namespace OSGeo {
namespace Gdal {

public class DriverManager {

    [CCode (cname="GDALGetDriverByName")]
    public static unowned Driver? get_driver_by_name(string name);
    [CCode (cname="GDALGetDriver")]
    public static unowned Driver? get_driver(int idx);
    
    [CCode (cname="GDALGetDriverCount")]
    public static int get_driver_count();

    [CCode (cname="GDALAllRegister")]
    public static void register_all();

}

[CCode (cname = "struct GDALDriverHS", free_function = "GDALDestroyDriver")]
[Compact]
public class Driver : Gdal.MajorObject {

    [CCode (cname = "GDALCreate")]
    public Dataset? create(string name, int xsize, int ysize, int bands, DataType type,
        [CCode (array_null_terminated = true)] string[] options);

}

[CCode (cname = "struct GDALMajorObjectHS")]
[Compact]
public class MajorObject {

    [CCode (cname="GDALGetDescription")]
    public unowned string get_description();

    [CCode (cname="GDALGetMetadata")]
    public string[] get_metadata(string domain = "");

}

[CCode (cname = "struct GDALDataType")]
public enum DataType {
    [CCode (cname = "GDT_Unknown")]
    UNKNOWN,
    [CCode (cname = "GDT_Byte")]
    BYTE,
    [CCode (cname = "GDT_UInt16")]
    UINT16,
    [CCode (cname = "GDT_Int16")]
    INT16
}

[CCode (cname = "struct GDALDatasetHS")]
[Compact]
public class Dataset {

}

}
}
