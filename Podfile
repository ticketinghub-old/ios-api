platform :ios, '7.0'

inhibit_all_warnings!

pod 'AFNetworking', '~> 2.2.0'
pod 'DCTCoreDataStack', '~> 1.1'

target :test, :exclusive => true do
    link_with 'iOS-apiTests'
    pod 'Expecta', '~> 0.2.3'
    pod 'Specta', '~> 0.2.1'
    pod 'OHHTTPStubs', '~> 3.1.0'
end
