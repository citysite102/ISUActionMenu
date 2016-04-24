Pod::Spec.new do |s|
  s.name             = "ISUActionMenu"
  s.version          = "0.1.3"
  s.summary          = "An interactive action menu button with gesture."

  s.homepage         = "https://github.com/citysite102"
  s.license          = 'MIT'
  s.author           = { "Samuel" => "citysite1025@gmail.com" }
  s.source           = { :git => "https://github.com/citysite102/ISUActionMenu.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/citysite102'

  s.ios.deployment_target = '8.0'
  s.ios.frameworks        = 'UIKit', 'QuartzCore'

  s.source_files = 'ISUActionMenu/Classes/**/*'
  s.resource_bundles = {
    'ISUActionMenu' => ['ISUActionMenu/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
