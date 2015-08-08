Pod::Spec.new do |s|

  s.name = "Validator"
  s.platform = :ios
  s.ios.deployment_target = '8.0'
  s.version = "0.0.8"
  s.summary = "Validator is a user input validation library written in Swift."
  s.description  = <<-DESC
  Validator is a user input validation library written in Swift.
  Features:
  - Validation rules
  - Swift type extensions
  - UIKit element extensions
  - An easily extended protocol-oriented implementation
  DESC

  s.homepage = "https://github.com/adamwaite/Validator"
  s.license = { :type => 'MIT', :file => 'LICENSE' }
  s.author = { "Adam Waite" => "adam@adamjwaite.co.uk" }
  s.social_media_url = "http://twitter.com/AdamWaite"

  s.source = { :git => "https://github.com/adamwaite/Validator.git", :tag => "v0.0.8" }
  s.source_files = 'Validator', 'Validator/**/*.swift'
  s.framework = 'UIKit'

end
