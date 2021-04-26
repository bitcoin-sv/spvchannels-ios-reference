#
# Be sure to run `pod lib lint SpvChannelsSdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SpvChannelsSdk'
  s.version          = '0.1.0'
  s.summary          = 'SDK to use with SPV channels service.'
  s.swift_version    = '5.3'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/bitcoin-sv/spvchannels-ios-reference'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Boris Herman' => 'boris@equaleyes.com' }
  s.source           = { :git => 'https://github.com/bitcoin-sv/spvchannels-ios-reference.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'

  s.source_files = 'SpvChannelsSdk/Classes/**/*'
  s.dependency 'Sodium'
  s.dependency 'Firebase'
  s.dependency 'Firebase/Messaging'
  s.frameworks = 'UIKit', 'Foundation'
end
