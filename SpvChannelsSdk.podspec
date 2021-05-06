#
# Be sure to run `pod lib lint SpvChannelsSdk.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SPV Channels iOS SDK Reference Implementation'
  s.version          = '1.0.0-beta'
  s.summary          = 'SDK to use with SPV channels service.'
  s.swift_version    = '5.3'
  s.description      = 'A mobile SDK to facilitate Simplified Payment Verification (SPV) development on the iOS platform.'

  s.homepage         = 'https://github.com/bitcoin-sv/spvchannels-ios-reference'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kenan Mamedoff' => 'k.mamedoff@nchain.com' }
  s.source           = { :git => 'https://github.com/bitcoin-sv/spvchannels-ios-reference.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.3'

  s.source_files = 'SpvChannelsSdk/Classes/**/*'
  s.dependency 'Sodium'
  s.dependency 'Firebase'
  s.dependency 'Firebase/Messaging'
  s.frameworks = 'UIKit', 'Foundation'
end
