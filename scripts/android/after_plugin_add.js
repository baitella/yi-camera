module.exports = function(context) {
    console.log('set sdk version 22');
    var fs = context.requireCordovaModule('fs');
    var path = context.requireCordovaModule('path');
    var etree = context.requireCordovaModule('elementtree');

    var manifestFilename = "AndroidManifest.xml";
    var manifest = path.join(
        context.opts.projectRoot,
        "platforms/android",
        manifestFilename
    );

    if (fs.existsSync(manifest)) {
        fs.readFile(manifest, 'utf8', function(err, data) {
            if (err) {
                throw new Error("Unable to find " + manifestFilename + ": " + err);
            }

            var xml = etree.parse(data)
            var root = xml.getroot();

            if (root.findall('*/service/[@android:name="com.euroart93.cordova.camera.CameraService"]').length !== 1) {
                var application = root.findall('./application')[0];

                console.log("Adding CameraService to application");

                var service = etree.SubElement(application, 'service');

                service.set('android:name', 'com.euroart93.cordova.camera.CameraService')

                var result = xml.write({indent: 4});

                fs.writeFile(manifest, result, 'utf8', function(err) {
                    if (err) {
                        throw new Error("Unable to write into " + manifestFilename + ": " + err);
                    }
                });
            }
            else {
                console.log("CameraService already in manifest");
            }
        });
    }
}
