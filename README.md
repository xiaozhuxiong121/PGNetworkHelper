[![PGNetworkHelper](http://upload-images.jianshu.io/upload_images/1340308-6532130a70265dab.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)](https://github.com/xiaozhuxiong121/PGNetworkHelper)  

[![CocoaPods compatible](https://img.shields.io/cocoapods/v/PGNetworkHelper.svg)](https://cocoapods.org/pods/PGNetworkHelper)
![](https://img.shields.io/badge/platform-iOS-red.svg) ![](https://img.shields.io/badge/language-Objective--C-orange.svg)
![](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg) 
 [![](https://img.shields.io/badge/jianshu-piggybear-red.svg)](http://www.jianshu.com/u/3740632b2002)

PINCache做为AFNetworking缓存层，将AFNetworking请求的数据缓存起来,支持取消当前网络请求，以及取消所有的网络请求，除了常用的Get，Post方法，也将上传图片以及下载文件进行了封装，使用方法及其简单。  
> PGNetworkHelper屏蔽了AFNetworking自带的缓存，并将PINCache缓存的key也用**MD5加密**，确保数据的安全。

**AFNetworking本身就带有缓存策略，为什么要使用PINCache作为缓存呢？**
> 第一，经过测试PINCache缓存比AFNetworking自带的缓存要快。  
> 第二，PINCache是将缓存数据进行了加密，更加安全。

# CocoaPods安装
```
pod 'PGNetworkHelper'
```
# 使用
``` oc
#import <PGNetworkHelper.h>

//设置baseUrl(必须要设置)
[PGNetAPIClient baseUrl:@"baseUrl"];
//设置SSL
[PGNetAPIClient policyWithPinningMode:AFSSLPinningModeNone];
//设置缓存路径
//多用户一般用userId来保存每个用户的缓存数据
[PGNetworkCache pathName:@"userId"];

//GET请求 只需要将cache设置为true就可以自动缓存
[PGNetworkHelper GET:@"api/user/login.json" parameters:nil cache:false responseCache:nil success:^(id responseObject) {
    NSLog(@"responseObject = %@", responseObject);
} failure:^(NSError *error) {
    NSLog(@"error = %@", error);
}];


//POST请求 只需要将cache设置为true就可以自动缓存
[PGNetworkHelper POST:@"api/user/login.json" parameters:@{@"username":@"test",@"password":@"test"} cache:false responseCache:nil success:^(id responseObject) {
    NSLog(@"responseObject = %@", responseObject);
} failure:^(NSError *error) {
    NSLog(@"error = %@", error);
}];
    
```
# 自动缓存
```
//只需要将cache设置为true就可以自动缓存，如果不想缓存就设置cache为false
[PGNetworkHelper GET:@"api/user/login.json" parameters:nil cache:true responseCache:^(id responseCache) {
	NSLog(@"responseCache = %@", responseCache);
}  success:^(id responseObject) {
	NSLog(@"responseObject = %@", responseObject);
} failure:^(NSError *error) {
	NSLog(@"error = %@", error);
}];
```
# 使用手动缓存
> 如果需要将数据先进行处理，然后在缓存也是可以的。

```
//cache设置为true
[PGNetworkHelper GET:@"api/user/login.json" parameters:nil cache:true responseCache:^(id responseCache) {
	NSLog(@"responseCache = %@", responseCache);
}  success:^(id responseObject) {
	//这里进行要缓存的数据，cacheKey就是url，如果有参数的话，就把参数拼接到cacheKey后面，下次就可以直接在responseCache block里面获取了
	[PGNetworkCache saveResponseCache:responseObject forKey:@""];
} failure:^(NSError *error) {
	NSLog(@"error = %@", error);
    }];
```
# 取消当前的网络请求
```
NSURLSessionTask *task = [PGNetworkHelper GET:@"api/user/login.json" parameters:nil cache:false responseCache:nil success:^(id responseObject) {
	NSLog(@"responseObject = %@", responseObject);
} failure:^(NSError *error) {
	NSLog(@"error = %@", error);
}];
[task cancel]; //取消当前网络请求
```

# 取消所有的网络请求
```
[PGNetworkHelper cancelAllOperations];
```

# 上传图片
```
/**
 *  上传图片文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param images     图片数组
 *  @param name       文件对应服务器上的字段
 *  @param fileName   文件名
 *  @param mimeType   图片文件的类型,例:png、jpeg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (__kindof NSURLSessionTask *)uploadWithURL:(NSString *)URL
                                  parameters:(NSDictionary *)parameters
                                      images:(NSArray<UIImage *> *)images
                                        name:(NSString *)name
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                    progress:(HttpProgress)progress
                                     success:(HttpRequestSuccess)success
                                     failure:(HttpRequestFailed)failure;
```

# 下载文件

```
/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(HttpProgress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(HttpRequestFailed)failure;
```

# 缓存数据
```
[PGNetworkCache saveResponseCache:@"CacheObject" forKey:@"cacheKey"];
```
# 获取缓存数据
```
[PGNetworkCache getResponseCacheForKey:@"cacheKey"];
```

# 许可证
PGNetworkHelper 使用 MIT 许可证，详情见 LICENSE 文件。