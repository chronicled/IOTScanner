#
# Be sure to run `pod lib lint IOTScanner.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'IOTScanner'
  s.version          = '0.2.0'
  s.summary          = 'Library that interacts with Chronicled Beacons'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Library allowing you to discover, read from, and write to Chronicled
Beacons
                       DESC

  s.homepage         = 'https://github.com/chronicled/IOTScanner'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dylan' => 'dylan@chronicled.com' }
  s.source           = { :git => 'https://github.com/chronicled/IOTScanner.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.3'

  s.source_files = 'IOTScanner/Classes/**/*'

  # s.resource_bundles = {
  #   'IOTScanner' => ['IOTScanner/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
