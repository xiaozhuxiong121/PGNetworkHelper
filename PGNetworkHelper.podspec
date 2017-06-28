Pod::Spec.new do |s|
  s.name         = "PGNetworkHelper"
  s.version      = "1.0.8"
  s.summary      = "PINCache做为AFNetworking缓存层，将AFNetworking请求的数据缓存起来。"
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
 
