#
# Be sure to run `pod lib lint YMExtension.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMExtension'
  s.version          = '0.1.6'
  s.summary          = 'YMExtension'
  s.description      = 'Swift extensions'
  s.homepage         = 'https://github.com/yanmingLiu/YMExtension'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lym' => 'lwb374402328@gmail.com' }
  s.source           = { :git => 'https://github.com/yanmingLiu/YMExtension.git', :tag => s.version.to_s }
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.requires_arc = true
  s.source_files  = "Sources", "Sources/*.{swift}"
  
end
