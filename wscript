def options(opt):
    opt.load('compiler_c')
    opt.load('vala')

def configure(conf):
    conf.load('compiler_c vala')
    conf.check_cfg(package='glib-2.0', uselib_store='GLIB', atleast_version='2.10.0', mandatory=1, args='--cflags --libs')
    conf.check_cfg(package='gdal', uselib_store='GDAL', mandatory=1, args='--cflags --libs')

    #conf.env.VALAFLAGS = '--enable-experimental-non-null'
    #conf.env.VALAFLAGS = '--enable-checking'
    conf.env.CFLAGS = ['-g']

def build(bld):
    bld.program(
        target='sample',
        uselib = 'GLIB GDAL',
        source = 'test/main.vala',
        packages = 'ogr osr gdal',
        vapi_dirs = 'vapi'
        )

