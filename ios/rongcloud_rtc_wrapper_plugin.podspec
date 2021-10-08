rtc_sdk_version = 'Unknown'

config = File.expand_path(File.join('..', '..', 'version.config'), __FILE__)

File.foreach(config) do |line|
    matches = line.match(/ios_rtc_sdk_version\=(.*)/)
    if matches
      rtc_sdk_version = matches[1].split("#")[0].strip
    end
end

if rtc_sdk_version == 'Unknown'
    raise "You need to config ios_rtc_sdk_version in version.config!!"
end

Pod::Spec.new do |s|
  s.name             = 'rongcloud_rtc_wrapper_plugin'
  s.version          = '0.0.1'
  s.summary          = 'Rongcloud rtc interface wrapper for flutter.'
  s.description      = 'Rongcloud rtc interface wrapper for flutter.'
  s.homepage         = 'https://www.rongcloud.cn/'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'GP-Moon' => 'pmgd19881226@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.static_framework = true

  s.vendored_frameworks = 'Frameworks/*.framework'
  s.frameworks = "AssetsLibrary","VideoToolbox", "GLKit", "MapKit", "ImageIO", "CoreLocation", "SystemConfiguration", "QuartzCore", "OpenGLES", "CoreVideo", "CoreTelephony", "CoreMedia", "CoreAudio", "CFNetwork", "AudioToolbox", "AVFoundation", "UIKit", "CoreGraphics"
  s.libraries = "c++","z","sqlite3","bz2"
  
  s.dependency 'Flutter'
  s.dependency 'RongCloudIM/IMLib', '5.1.4.1'
  s.dependency 'RongCloudRTC/RongRTCLib', rtc_sdk_version

  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end