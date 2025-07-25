#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint superwallkit_flutter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'superwallkit_flutter'
  s.version          = '0.0.1'
  s.summary          = 'Superwall: In-App Paywalls Made Easy'
  s.description      = 'Paywall infrastructure for mobile apps :) we make things like editing your paywall and running price tests as easy as clicking a few buttons. superwall.com'
  s.homepage         = 'https://superwall.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Superwall' => 'jake@superwall.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'SuperwallKit', '4.5.2'
  s.platform = :ios, '14.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
