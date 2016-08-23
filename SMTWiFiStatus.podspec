#
# Be sure to run `pod lib lint SMTWiFiStatus.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SMTWiFiStatus'
  s.version          = '1.0.1'
  s.summary          = 'SMTWiFiStatus is some functions to check for WiFi Status.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
SMTWiFiStatus is base on blog post in 'http://www.enigmaticape.com/blog/determine-wifi-enabled-ios-one-weird-trick' to help out developers to check for WiFi status of iOS nearby.
DESC

  s.homepage         = 'https://github.com/alirp88/SMTWiFiStatus'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Ali Rp' => 'riahipour.ali@gmail.com' }
  s.source           = { :git => 'https://github.com/alirp88/SMTWiFiStatus.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/alirp88'

  s.ios.deployment_target = '8.0'

  s.source_files = 'SMTWiFiStatus/Classes/SMTWiFiStatus.*'
end
