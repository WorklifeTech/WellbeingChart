#
# Be sure to run `pod lib lint WellbeingChart.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WellbeingChart'
  s.version          = '2.0.9'
  s.summary          = 'Wellbeing line chart using Charts library.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/WorklifeTech/WellbeingChart.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'radohecko' => 'rhe@worklifebarometer.com' }
  s.source           = { :git => 'https://github.com/WorklifeTech/WellbeingChart.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'
  s.swift_versions = '5.0'

  s.source_files = 'WellbeingChart/Classes/**/*'
  
   s.resource_bundles = {
     'Fonts' => ['WellbeingChart/Assets/*.{ttf}']
   }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'

  s.dependency 'Charts', '~> 4.1.0'
  s.dependency 'TinyConstraints', '~> 4.0.1'
end
