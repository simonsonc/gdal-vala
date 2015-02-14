using OSGeo.Osr;
using OSGeo.Ogr;

int main()
{
    var sr = new SpatialReference();
    sr.import_from_epsg(26915);
    string str = "";
    sr.export_to_wkt(out str);
    stdout.printf("wkt: %s\n", str);

    sr.export_to_proj4(out str);
    stdout.printf("proj4: %s\n", str);

    var ls = new Geometry(GeometryType.LINE_STRING);
    ls.add_point(1, 2, 3);
    ls.export_to_wkt(out str);
    stdout.printf("geom wkt: %s\n", str);
    stdout.printf("geom name: %s\n", ls.get_geometry_name());
    stdout.printf("geom type: %s\n", ls.get_geometry_type().to_string());
    Envelope ls_extent;
    ls.get_envelope(out ls_extent);
    stdout.printf("geom extent (%f, %f)-(%f, %f)\n", ls_extent.minx, ls_extent.miny, ls_extent.maxx, ls_extent.maxy);
    stdout.printf("geom gml: %s\n", ls.export_to_gml());
    stdout.printf("geom kml: %s\n", ls.export_to_kml());
    stdout.printf("geom json: %s\n", ls.export_to_json());

    var cloned = ls.clone();
    stdout.printf("cloned geom name: %s\n", cloned.get_geometry_name());

    DriverRegistrar.register_all();
    var count = DriverRegistrar.get_driver_count();
    stdout.printf("driver count: %d\n", count);
    for ( var i = 0; i < count; i++ ) {
        stdout.printf("driver %d: %s\n", i,
                DriverRegistrar.get_driver(i).get_description());
    }

    unowned Driver? geojson = DriverRegistrar.get_driver_by_name("GeoJSON");
    var ds = geojson.create_datasource("test.json", {});
    stdout.printf("datasource name: %s\n", ds.get_name());

    var layer = ds.create_layer("layer1", sr, GeometryType.LINE_STRING, {});
    stdout.printf("layer name: %s\n", layer.get_name());

    var field = new FieldDefn("field1", FieldType.STRING);
    field.set_width(16);
    layer.create_field(field);

    var feature = new Feature(layer.get_layer_defn());
    feature.set_geometry(ls);
    feature.set_field_string(0, "teststring");

    layer.create_feature(feature);

    var s_ds = DriverRegistrar.open("sample.json");
    var s_layer = s_ds.get_layer(0);
    stdout.printf("src layer name: %s\n", s_layer.get_name());
    stdout.printf("src layer geom type: %s\n", s_layer.get_geometry_type().to_string());
    stdout.printf("src layer spatial filter: %p\n", s_layer.get_spatial_filter());
    stdout.printf("src layer spatial ref: %s\n", s_layer.get_spatial_reference().to_string());

    Envelope extent;
    s_layer.get_extent(out extent, true);
    stdout.printf("src extent (%f, %f)-(%f, %f)\n", extent.minx, extent.miny, extent.maxx, extent.maxy);

    for ( int64 i = 0; i < s_layer.get_feature_count(); i++ ) {
        var s_feature = s_layer.get_feature(i);
        stdout.printf("src feature: %i, %s, %s\n",
            (int)i, s_feature.get_field_string(0), s_feature.get_geometry().to_string());
    }

    OSGeo.Gdal.DriverManager.register_all();
    var gdal_count = OSGeo.Gdal.DriverManager.get_driver_count();
    stdout.printf("driver count: %d\n", count);
    for ( var i = 0; i < gdal_count; i++ ) {
        stdout.printf("driver %d: %s\n", i,
                OSGeo.Gdal.DriverManager.get_driver(i).get_description());
    }

    return 0;
}
