platform :ios, "8.0"

workspace 'GitHubUsers.xcworkspace'
xcodeproj 'GitHubUsers.xcodeproj'

use_frameworks!

def shared_pods
	pod 'RxSwift'
	pod 'RxCocoa'
	pod 'SwiftyJSON'
	pod 'Alamofire'
	pod 'RxAlamofire'
end

target 'GitHubUsers' do
	shared_pods
	pod 'AlamofireImage'
	pod 'PKHUD'
end

target 'GitHubUsersTests' do
	shared_pods
end

target 'GitHubUsersUITests' do
	shared_pods
end

