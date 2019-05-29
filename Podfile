platform :ios, '12.0'
install! 'cocoapods', :generate_multiple_pod_projects => true

target 'BitCoinCoding' do

  use_frameworks!

  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'RxCoreLocation'
  
  pod 'RealmSwift'


# testing pods
  target 'BitCoinCodingTests' do
    inherit! :search_paths

    pod 'RxTest'
    pod 'RxBlocking'

  end

end
