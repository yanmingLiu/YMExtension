#
# Be sure to run `pod lib lint YMExtension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMExtension'
  s.version          = '0.1.0'
  s.summary          = 'YMExtension of Swift'

  s.description      = 'Swift extensions'

  s.homepage         = 'https://github.com/lym/YMExtension'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lym' => 'lwb374402328@gmail.com' }
  s.source           = { :git => 'https://github.com/lym/YMExtension.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.requires_arc = true

  s.source_files = 'YMExtension/Classes/*.{swift}'
  
end
