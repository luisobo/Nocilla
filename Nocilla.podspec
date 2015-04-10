Pod::Spec.new do |s|
  s.name         = "Nocilla"
  s.version      = "0.9.0"
  s.summary      = "Stunning HTTP stubbing for iOS. Testing HTTP requests has never been easier."
  s.homepage     = "https://github.com/luisobo/Nocilla"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Luis Solano" => "contact@luissolano.com" }

  s.source       = { :git => "https://github.com/luisobo/Nocilla.git", :tag => "0.9.0" }

  s.ios.deployment_target = '4.0'
  s.osx.deployment_target = '10.7'

  s.source_files = 'Nocilla/**/*.{h,m}'

  s.public_header_files = [
    'Nocilla/LSHTTPBody.h',
    'Nocilla/LSMatcheable.h',
    'Nocilla/LSNocilla.h',
    'Nocilla/LSStubRequestDSL.h',
    'Nocilla/LSStubResponseDSL.h',
    'Nocilla/Nocilla.h',
    'Nocilla/NSData+Matcheable.h',
    'Nocilla/NSData+Nocilla.h',
    'Nocilla/NSRegularExpression+Matcheable.h',
    'Nocilla/NSString+Matcheable.h',
    'Nocilla/NSString+Nocilla.h'
  ]

  s.requires_arc = true
  s.frameworks = 'CFNetwork'
end
