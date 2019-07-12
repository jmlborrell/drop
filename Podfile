platform :ios, '12.2'

target 'drop' do
  use_frameworks!

  pod 'SnapKit', '~> 5.0.0'
  pod 'RxSwift', '~> 5'
  pod 'RxCocoa', '~> 5'
  pod 'RxDataSources', '~> 4'

  target 'dropTests' do
    inherit! :search_paths
    pod 'RxBlocking', '~> 5'
    pod 'RxTest', '~> 5'
  end

  target 'dropUITests' do
    inherit! :search_paths
  end

end
