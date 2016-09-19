use_frameworks!

target 'LJReader' do

    pod 'Alamofire', '~> 3'
    pod 'AlamofireImage', '~> 2'

    pod 'AEXML', '~> 2'
    pod 'ReachabilitySwift', '~> 2'

    pod 'PureLayout', '~> 3'
    pod 'XCGLogger', :git => 'https://github.com/DaveWoodCom/XCGLogger.git', :branch => 'swift_2.3'

    target 'LJReaderTests' do
        inherit! :search_paths
    end

    target 'LJReaderUITests' do
        inherit! :search_paths
    end
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |configuration|
            configuration.build_settings['SWIFT_VERSION'] = "2.3"
        end
    end
end
