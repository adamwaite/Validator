Pod::Spec.new do |s|

  s.name = 'Validator'
  s.platform = :ios
  s.ios.deployment_target = '9.0'
  s.tvos.deployment_target = '10.0'
  s.swift_version = '5'
  s.version = '3.2.1'
  s.summary = 'Validator is a user input validation library written in Swift.'
  s.description  = <<-DESC
  Validator is a user input validation library written in Swift.
  Features:
  [x] Validation rules:
    [x] Required
    [x] Equality
    [x] Comparison
    [x] Length (min, max, range)
    [x] Pattern (email, password constraints and more...)
    [x] Contains
    [x] URL
    [x] Payment card (Luhn validated, accepted types)
    [x] Condition (quickly write your own)
  [x] Swift standard library type extensions with one API (not just strings!)
  [x] UIKit element extensions
  [x] Open validation error types
  [x] An open protocol-oriented implementation
  [x] Comprehensive test coverage
  [x] Comprehensive code documentation
  DESC

  s.homepage = 'https://github.com/adamwaite/Validator'
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { 'Adam Waite' => 'adam@adamjwaite.co.uk' }
  s.social_media_url = 'http://twitter.com/AdamWaite'

  s.source = { :git => 'https://github.com/adamwaite/Validator.git', :tag => 'v3.2.1' }
  s.source_files = 'Validator', 'Validator/Sources/**/*.swift'
  s.framework = 'UIKit'

end
