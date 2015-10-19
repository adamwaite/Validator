Pod::Spec.new do |s|

  s.name = "Validator"
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.version = "0.0.9"
  s.summary = "Validator is a user input validation library written in Swift."
  s.description  = <<-DESC
  Validator is a user input validation library written in Swift.
  Features:
  - [x] Validation rules
  - [x] Swift standard library type extensions
  - [x] UIKit element extensions
  - [x] Flexible validation error types
  - [x] An open protocol-oriented implementation
  - [x] Comprehensive test coverage
  DESC

  s.homepage = "https://github.com/adamwaite/Validator"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { "Adam Waite" => "adam@adamjwaite.co.uk" }
  s.social_media_url = "http://twitter.com/AdamWaite"

  s.source = { :git => "https://github.com/adamwaite/Validator.git", :tag => "v0.0.9" }
  s.source_files = 'Validator', 'Validator/Validator/**/*.swift'
  s.framework = 'UIKit'

end
