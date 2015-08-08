Pod::Spec.new do |s|

  s.name = "Validator"
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
  s.platform = :ios
  s.platform = :ios, '8.0'
  s.source = { :git => "https://github.com/adamwaite/Validator.git", :tag => "v0.0.8" }
  s.source_files = 'Validator', 'Validator/**/*.swift'
  s.public_header_files = 'AJWValidator/AJWValidator.h', 'AJWValidator/UIView+AJWValidator.h'
  s.requires_arc = true

end
