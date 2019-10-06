Pod::Spec.new do |s|

  s.name = "FastMessage"
  s.version = "1.0"
  s.summary = "It is a simple library for displaying messages on the screen"
  s.homepage = "https://github.com/IvanBogdaanov/FastMessage"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "IvanBogdaanov" => "IvanBogdaanov@gmail.com" }
  s.source = { :git => "https://github.com/IvanBogdaanov/FastMessage.git", :tag => "1.0.0" }

  s.ios.deployment_target = "9.0"

  s.source_files = 'FastMessage/*.swift'

  s.swift_version = "4.2"

end