Pod::Spec.new do |s|
    s.name             = 'OpenCV'
    s.version          = '3.1'
    s.summary          = 'A podspec that builds OpenCV as a dynamic library.'

    s.description      = <<-DESC
This is a podspec that builds OpenCV 3.1 as a dynamic library. This is useful when you want to use OpenCV as a dependency of another CocoaPod.
    DESC

    s.homepage         = 'https://github.com/edc1591/opencv'
    s.license          = { :type => '3-clause BSD', :file => 'LICENSE' }
    s.author           = { 'Evan Coleman' => 'e@edc.me' }
    s.source           = { :git => 'https://github.com/edc1591/opencv.git', :commit => '799faddbc6c82e623458a3fafebcd9bf368589cb' }

    s.ios.deployment_target = '8.4'
    s.preserve_paths = [ "ios/libopencv2.dylib", "ios/libjpeg.dylib", "ios/libpng.dylib", "ios/libzlib.dylib", "ios/include" ]
    s.public_header_files = "ios/include/**/*{.h,.hpp}"
    s.header_dir = "opencv2"
    s.header_mappings_dir = "ios/include/"
    s.vendored_libraries = [ "ios/libopencv2.dylib", "ios/libjpeg.dylib", "ios/libpng.dylib", "ios/libzlib.dylib" ]
    s.source_files = "ios/include/**/*{.h,.hpp}"

    s.requires_arc = false
    s.prepare_command = "/usr/bin/python platforms/ios/build_framework.py ios"
end
