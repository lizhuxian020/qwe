#
# Be sure to run `pod lib lint KMTGlobe.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KMTGlobe'
  s.version          = '0.1.0'
  s.summary          = 'A short description of KMTGlobe.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '康美通GLOBE模块!!!!!!'
  s.static_framework = true # 不加这个就报错=.=
  s.homepage         = 'https://github.com/lizhuxian@kmt518.com/KMTGlobe'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lizhuxian@ktm518.com' => 'lizhuxian@ktm518.com' }
  s.source           = { :git => 'https://github.com/lizhuxian@kmt518.com/KMTGlobe.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  # s.source_files = 'KMTGlobe/Classes/**/*'
  s.prefix_header_file = 'KMTGlobe/Classes/Interface/Macro/Macro.h'
  s.subspec 'Interface' do |inter|
      inter.source_files = 'KMTGlobe/Classes/Interface/Macro/**/*.{h,m}'
      inter.dependency 'KMTGlobe/Module'
  end
  
  s.subspec 'Module' do |mo|
      mo.source_files = 'KMTGlobe/Classes/KMTGlobel/**/*.{h,m}'
      # mo.dependency 'ZXConvenientCode/Interface'
  end
  s.resource = "KMTGlobe/Classes/KMTGlobel/**/*.{xib,sqlite}"
  
  # s.resource_bundles = {
  #   'KMTGlobe' => ['KMTGlobe/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AMapSearch', '~> 6.1.1'
  s.dependency 'AMapLocation', '~> 2.6.0'
  s.dependency 'AMapNavi', '~> 6.1.1'
  s.dependency 'AFNetworking', '~> 3.2.0'
  s.dependency 'SVProgressHUD', '~> 2.2.5'
  s.dependency 'CJLabel', '~> 4.6.1'
  s.dependency 'SDWebImage', '~> 4.4.1'
  s.dependency 'MJRefresh', '~> 3.1.15.3'
  s.dependency 'JSONModel', '~> 1.7.0'
  s.dependency 'MBProgressHUD', '~> 1.1.0'
  s.dependency 'IQKeyboardManager', '~> 6.0.3'
  s.dependency 'FMDB', '~> 2.7.2'
  s.dependency 'Masonry', '~> 1.1.0'
  s.dependency 'SDCycleScrollView', '~> 1.75'
  s.dependency 'CocoaLumberjack'
  s.dependency 'XHLaunchAd', '~> 3.9.7'
end
