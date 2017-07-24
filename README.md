# PGNetworkHelper
PINCache做为AFNetworking缓存层，将AFNetworking请求的数据缓存起来,支持取消当前网络请求，以及取消所有的网络请求，使用方法及其简单。  
> PGNetworkHelper屏蔽了AFNetworking自带的缓存，并将PINCache缓存的key也用MD5进行了加密，确保数据的安全。

**AFNetworking本身就带有缓存策略，为什么要使用PINCache作为缓存呢？**
> 第一，经过测试PINCache缓存比AFNetworking自带的缓存要快。
> 第二，PINCache是将缓存数据进行了加密，更加安全。

# Installation with CocoaPods
```
pod 'PGNetworkHelper'
```
# Usage
``` oc
#import <PGNetworkHelper.h>

//设置baseUrl(必须要设置)
[PGNetAPIClient baseUrl:@"baseUrl"];
//设置SSL
[PGNetAPIClient policyWithPinningMode:AFSSLPinningModeNone];
//设置缓存路径
//多用户一般用userId来保存每个用户的缓存数据
[PGNetworkCache pathName:@"userId"];
//GET请求
[PGNetworkHelper GET:@"api/user/login.json" parameters:nil cache:false responseCache:nil success:^(id responseObject) {
    NSLog(@"error = %@", responseObject);
} failure:^(NSError *error) {
        NSLog(@"error = %@", error);
}];
//POST请求
[PGNetworkHelper POST:@"api/user/login.json" parameters:@{@"username":@"test",@"password":@"test"} cache:false responseCache:nil success:^(id responseObject) {
    NSLog(@"error = %@", responseObject);
} failure:^(NSError *error) {
    NSLog(@"error = %@", error);
}];
    
```
# API
## PGNetworkHelper
```oc
/**
 *  GET请求
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param cache         是否缓存数据
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
                    cache:(BOOL)cache
            responseCache:(HttpRequestCache)responseCache
                  success:(HttpRequestSuccess)success
                  failure:(HttpRequestFailed)failure;

/**
 *  POST请求
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param cache         是否缓存数据
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancle方法
 */
+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                     cache:(BOOL)cache
             responseCache:(HttpRequestCache)responseCache
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailed)failure;
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
## PGNetworkCache
``` oc
/**
 *  设置缓存路径
 *
 *  @param name 路径文件夹的名称
 */
+ (void)pathName:(NSString *)name;

/**
 *  缓存网络数据
 *
 *  @param responseCache 服务器返回的数据
 *  @param key           缓存数据对应的key值,推荐填入请求的URL
 */
+ (void)saveResponseCache:(id <NSCoding>)responseCache forKey:(NSString *)key;

/**
 *  取出缓存的数据
 *
 *  @param key 根据存入时候填入的key值来取出对应的数据
 *
 *  @return 缓存的数据
 */
+ (id)getResponseCacheForKey:(NSString *)key;

/**
 *
 *  删除缓存
 *  @param key 要删除缓存的key值
 */
+ (void)removeResponseCacheForKey:(NSString *)key;

/**
 *  删除所有的缓存
 */
+ (void)removeAllResponseCache;
```
## PGNetAPIClient
``` oc
/**
 *  设置baseUrl
 */
+ (void)baseUrl:(NSString *)baseUrl;
/**
 *  设置ssl
 */
+ (void)policyWithPinningMode:(AFSSLPinningMode)pinningMode;
```
