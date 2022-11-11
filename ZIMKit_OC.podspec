#
# Be sure to run `pod lib lint ZIMKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZIMKit_OC'
  s.version          = '1.2.0'
  s.summary          = 'ZIM UIKit of Objective-C.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/ZEGOCLOUD/zego_inapp_chat_uikit_ios_oc'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wukun' => 'wukun@zego.im' }
  s.source           = { :git => 'https://github.com/ZEGOCLOUD/zego_inapp_chat_uikit_ios_oc.git', :tag => "#{s.version}" }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'ZIMKit/**/*.{h,m}'

  # 是否是静态库 这个地方很重要 假如不写这句打出来的包 就是动态库 不能使用 一运行会报错 image not found
#  s.static_framework = true
  # 链接设置 重要
#  s.xcconfig = { "OTHER_LDFLAGS" => "-ObjC", "ENABLE_BITCODE" => "NO" }
  
#  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64', 'GCC_PREPROCESSOR_DEFINITIONS[config=Debug]' => '$(inherited) _ZX_ENVIRONMENT_DEBUG_=1001', 'GCC_PREPROCESSOR_DEFINITIONS' =>
#  'GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1' }
#  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }  #必须
#
#  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }

# 必须要加,ZIM 不支持i386
#  s.xcconfig = {
#  'VALID_ARCHS' =>  'arm64 x86_64',
#  }
#
  s.cocoapods_version       = '>= 1.10.0'
  
  s.ios.resource_bundles = {
    'ChatResources' => ['ZIMKit/Resources/ChatResources/*'],
    'CommonResources' => ['ZIMKit/Resources/CommonResources/*'],
    'ConversationResources' => ['ZIMKit/Resources/ConversationResources/*'],
    'GroupResources' => ['ZIMKit/Resources/GroupResources/*'],
    'GKPhotoBrowser' => ['ZIMKit/Resources/GKPhotoBrowser/*']
  }
  
  s.ios.public_header_files = 'ZIMKit/**/*.h'
  
   s.dependency 'Masonry', '1.1.0'
   s.dependency 'YYText', '1.0.7'
   s.dependency 'MJRefresh', '3.1.15.3'
   s.dependency 'TZImagePickerController', '3.8.3'
   s.dependency 'SDWebImage', '~>5.13.2'
   s.dependency 'ZIM', '2.4.2'
end
