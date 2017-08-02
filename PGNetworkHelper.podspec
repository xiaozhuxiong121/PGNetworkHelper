Pod::Spec.new do |s|
  s.name         = "PGNetworkHelper"
  s.version      = "2.0.1"
  s.summary      = "PINCache做为AFNetworking缓存层，将AFNetworking请求的数据缓存起来,支持取消当前网络请求，以及取消所有的网络请求，除了常用的Get，Post方法，也将上传图片以及下载文件进行了封装，并且支持同步请求，使用方法及其简单。"
  s.homepage     = "https://github.com/xiaozhuxiong121/PGNetworkHelper"
  s.license      = "MIT"
  s.author       = { "piggybear" => "piggybear_net@163.com" }
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/xiaozhuxiong121/PGNetworkHelper.git", :tag => s.version }
  s.source_files = "PGNetworkHelper", "PGNetworkHelper/*.{h,m}"
  s.frameworks   = "UIKit"
  s.requires_arc = true

  s.dependency 'AFNetworking'
  s.dependency 'PINCache'
end
 
 
