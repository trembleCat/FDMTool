#
# Be sure to run `pod lib lint QHFunctionalKit_iOS.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'QHFunctionalKit_iOS'
  s.version          = '0.4.2'
  s.summary          = '以青湖为基准的iOS功能性组件库'
  s.homepage         = 'http://192.168.1.240/jingmingxuan/QHFunctionalKit_iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'trembleCat' => 'fa_dou_miao@163.com' }
  s.source           = { :git => 'http://192.168.0.1/jingmingxuan/QHFunctionalKit_iOS.git', :tag => s.version.to_s }
  s.ios.deployment_target = '10.0'
  s.dependency 'SnapKit'
  
  s.subspec 'QHAlert' do |alert|
      alert.source_files = 'QHFunctionalKit_iOS/Classes/QHAlert/**/*'
  end

  s.subspec 'QHPopup' do |popup|
      popup.source_files = 'QHFunctionalKit_iOS/Classes/QHPopup/**/*'
  end
  
  s.subspec 'QHInput' do |input|
      input.source_files = 'QHFunctionalKit_iOS/Classes/QHInput/**/*'
      input.resource_bundles = {
        'QHInput' => ['QHFunctionalKit_iOS/Assets/QHInput/*.{xcassets}']
      }
  end
  
end
