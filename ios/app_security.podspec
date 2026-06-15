Pod::Spec.new do |s|
  s.name             = 'app_security'
  s.version          = '1.0.8'
  s.summary          = 'App security for Android and iOS.'
  s.description      = <<-DESC
App security for Android and iOS.
                       DESC
  s.homepage         = 'https://github.com/deepak07082/app_security'
  s.license          = { :file => '../LICENSE' }
  s.author           = 'Deepak'
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency       'Flutter'
  s.platform         = :ios, '15.0'
  s.swift_version    = ["4.0", "4.1", "4.2", "5.0", "5.1", "5.2", "5.3", "5.4", "5.5", "5.6", "5.7", "5.8", "5.9"]
end