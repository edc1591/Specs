Pod::Spec.new do |s|
    s.name             = 'OpenCV'
    s.version          = '3.1.0'
    s.summary          = 'OpenCV (Computer Vision) for iOS.'

    s.description      = <<-DESC
OpenCV: open source computer vision library

    Homepage: http://opencv.org
    Online docs: http://docs.opencv.org
    Q&A forum: http://answers.opencv.org
    Dev zone: http://code.opencv.org
    DESC

    s.homepage         = 'https://github.com/opencv/opencv'
    s.license          = { :type => '3-clause BSD', :file => 'LICENSE' }
    s.authors          = 'opencv.org'
    s.source           = { :git => 'https://github.com/opencv/opencv.git', :commit => 'f2e9588c937ada9f5410773b042b3446d9d80b3d' }

    s.ios.deployment_target = '8.4'
    s.source_files = [ "build/sources/build/**/*{.h,.hpp,.c,.cpp,.inc,.mm}", "build/sources/modules/**/src/**/*{.h,.hpp,.c,.cpp,.inc,.mm}", "modules/**/include/**/*{.h,.hpp}", "build/*{.h,.hpp}" ]
    s.public_header_files = [ "build/install/include/**/*{.h,.hpp}" ]
    s.preserve_paths = [ "build", "3rdparty/libjpeg", "3rdparty/libpng" ]
    s.header_dir = "opencv2"
    s.header_mappings_dir = "build/install/include"
    s.module_name = "OpenCV"
    s.xcconfig = { 
       'HEADER_SEARCH_PATHS' => '"$(inherited)" "${PODS_ROOT}/OpenCV/build/install/include/**" "${PODS_ROOT}/OpenCV/build/modules/**"',
       'GCC_PREPROCESSOR_DEFINITIONS' => '__OPENCV_BUILD=1',
       'CLANG_ALLOW_NON_MODULAR_INCLUDES_IN_FRAMEWORK_MODULES' => 'YES',
       'WARNING_CFLAGS' => '"$(inherited)" "-Wno-deprecated-register" "-Wno-deprecated-declarations" "-Wno-implicit-function-declaration" "-Wno-unused-variable"'
    }
    s.requires_arc = false
    s.libraries = [ 'z', 'stdc++' ]
    s.frameworks = [
        "Accelerate",
        "AssetsLibrary",
        "AVFoundation",
        "CoreGraphics",
        "CoreImage",
        "CoreMedia",
        "CoreVideo",
        "Foundation",
        "QuartzCore",
        "UIKit"
    ]

    s.prepare_command = <<-CMD
        mkdir build
        cd build
        cmake -GXcode -DAPPLE_FRAMEWORK=ON -DCMAKE_INSTALL_PREFIX=install -DCMAKE_BUILD_TYPE=Release -DCMAKE_TOOLCHAIN_FILE=../platforms/ios/cmake/Toolchains/Toolchain-iPhoneOS_Xcode.cmake -DENABLE_NEON=ON ../
        make -C ./ -f modules/world/CMakeScripts/opencv_world_cmakeRulesBuildPhase.makeRelease all
        make -C ./ -f CMakeScripts/ZERO_CHECK_cmakeRulesBuildPhase.makeRelease all
        make -C ./ -f CMakeScripts/ALL_BUILD_cmakeRulesBuildPhase.makeRelease all
        sed -i '' 's/\\(^.*build\\/3rdparty\\/zlib\\/cmake_install.cmake\\)/#\1/g' cmake_install.cmake
        sed -i '' 's/\\(^.*build\\/3rdparty\\/libjpeg\\/cmake_install.cmake\\)/#\1/g' cmake_install.cmake
        sed -i '' 's/\\(^.*build\\/3rdparty\\/libpng\\/cmake_install.cmake\\)/#\1/g' cmake_install.cmake
        cmake -P cmake_install.cmake
        mkdir sources
        cd sources
        PARENT_DIR=`pwd | xargs -n1 dirname | xargs -n1 dirname`/
        SOURCE_FILES=`egrep "^\\/.*\\.([ch]+p*|inc)*$" ../modules/world/CMakeFiles/opencv_world.dir/Labels.txt`
        echo $SOURCE_FILES | sed "s~$PARENT_DIR~~g" | xargs -n1 dirname | xargs -n1 mkdir -p
        for path in $SOURCE_FILES; do echo $path | sed "s~$PARENT_DIR~~g" | xargs cp $path ; done
        cp -R ../../modules/core/include/opencv2/core/opencl ../install/include/opencv2/core/
        cp ../../modules/videoio/src/cap_intelperc.hpp modules/videoio/src/
        cp ../../modules/videoio/src/cap_dshow.hpp modules/videoio/src/
        cp ../../modules/videoio/src/cap_avfoundation.mm modules/videoio/src/
        cp ../../modules/videoio/src/cap_ios_abstract_camera.mm modules/videoio/src/
        cp ../../modules/videoio/src/cap_ios_photo_camera.mm modules/videoio/src/
        cp ../../modules/videoio/src/cap_ios_video_camera.mm modules/videoio/src/
        mv ../*.hpp ../install/include
        mv ../*.h ../install/include
        rm ../../3rdparty/libjpeg/jmemansi.c
        mv ../../3rdparty/libpng/pnginfo.h ../../3rdparty/libpng/pnginfo_old.h
        perl -pe 's/(#define PNGINFO_H)/#define PNGINFO_H\n\n#include "pngstruct.h"/g' ../../3rdparty/libpng/pnginfo_old.h > ../../3rdparty/libpng/pnginfo.h
    CMD

    s.default_subspecs = 'libjpeg', 'libpng'

    s.subspec 'libjpeg' do |libjpeg|
        libjpeg.source_files = '3rdparty/libjpeg/**/*{.h,.c}'
        libjpeg.private_header_files = "3rdparty/libjpeg/**/*{.h}"
    end

    s.subspec 'libpng' do |libpng|
        libpng.source_files = '3rdparty/libpng/**/*{.h,.c,.S}'
        libpng.private_header_files = "3rdparty/libpng/**/*{.h}"
    end
end
