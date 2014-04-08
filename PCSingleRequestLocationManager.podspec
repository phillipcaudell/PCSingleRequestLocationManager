Pod::Spec.new do |s|
  s.name         = "PCSingleRequestLocationManager"
  s.version      = "0.0.1"
  s.summary      = "PCSingleRequestLocationManager is an alternative for CLLocationManager which only returns a single location once it meets a set number of criteria."

  s.homepage     = "https://github.com/phillipcaudell/PCSingleRequestLocationManager"
  s.license      = 'MIT'
  s.author             = { "Phillip Caudell" => "phillipcaudell@gmail.com" }
  s.source       = { :git => "https://github.com/phillipcaudell/PCSingleRequestLocationManager.git", :commit => "2e49e2c6dd6f953167b03925b151a2581e47a823" }
  s.source_files  = 'Classes', '*.{h,m}'
  s.framework  = 'CoreLocation'
end
