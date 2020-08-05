use_frameworks!

# ruby语法
# target数组 如果有新的target直接加入该数组

targetsArray = [
'PROJECT_NAME'
]

# 循环
targetsArray.each do |t|
    target t do
	pod 'SnapKit', '~> 5.0.1'
	pod 'Alamofire's, '~> 5.1.0'
	pod 'ObjectMapper', '~> 3.5.2'
	pod 'YYCache', '~> 1.0.4'
	pod 'WechatOpenSDK', '~> 1.8.7'
  	pod 'AlipaySDK-iOS', '~> 15.6.8'
  	pod 'MBProgressHUD', '~> 1.2.0'
    end
end

