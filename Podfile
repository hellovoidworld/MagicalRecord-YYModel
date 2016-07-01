source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '7.0'

target "HVWMagicalRecord+YYModel" do
pod 'MagicalRecord'
pod 'YYModel'
end

post_install do |installer_representation|
  installer_representation.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
      end
  end
end