//
//  PGNetworkHelper.m
//
//  Created by piggybear on 16/8/22.
//  Copyright © 2016年 piggybear. All rights reserved.
//

#import "PGNetworkHelper.h"

@implementation PGNetworkHelper

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(id)parameters
                    cache:(BOOL)cache
            responseCache:(HttpRequestCache)responseCache
                  success:(HttpRequestSuccess)success
                  failure:(HttpRequestFailed)failure {
    
    NSString *cacheKey = URL;
    if (parameters) {
        cacheKey = [URL stringByAppendingString:[self dictionaryConvertJsonString:parameters]];
    }
    if (responseCache) {
        responseCache([PGNetworkCache getResponseCacheForKey:cacheKey]);
    }
    AFHTTPSessionManager *manager = [self manager];
    
    return [manager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (cache) {
            [PGNetworkCache saveResponseCache:responseObject forKey:cacheKey];
        }
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure ? failure(error) : nil;
    }];
}

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(id)parameters
                     cache:(BOOL)cache
             responseCache:(HttpRequestCache)responseCache
                   success:(HttpRequestSuccess)success
                   failure:(HttpRequestFailed)failure {
    
    NSString *cacheKey = URL;
    if (parameters) {
        cacheKey = [URL stringByAppendingString:[self dictionaryConvertJsonString:parameters]];
    }
    if (responseCache) {
        responseCache([PGNetworkCache getResponseCacheForKey:cacheKey]);
    }
//    NSLog(@"cacheKey = %@", cacheKey);
    AFHTTPSessionManager *manager = [self manager];
    return [manager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (cache) {
            [PGNetworkCache saveResponseCache:responseObject forKey:cacheKey];
        }
        
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark - 上传图片文件
+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                           progress:(HttpProgress)progress
                            success:(HttpRequestSuccess)success
                            failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self manager];
    return [manager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        //压缩-添加-上传图片
        [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
            NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
            NSInteger index = idx;
            NSString *fileName1 = [NSString stringWithFormat:@"%@%ld.png", fileName, index];
            NSString *name1 = [NSString stringWithFormat:@"%@%ld", name, index];
            [formData appendPartWithFileData:imageData name:name1 fileName:fileName1 mimeType:[NSString stringWithFormat:@"image/%@",mimeType?mimeType:@"jpeg"]];
        }];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        progress ? progress(uploadProgress) : nil;
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        success(responseObject);
        //        NSLog(@"responseObject = %@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        failure ? failure(error) : nil;
        //        NSLog(@"error = %@",error);
    }];
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(HttpProgress)progress
                              success:(void(^)(NSString *))success
                              failure:(HttpRequestFailed)failure
{
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    
    AFHTTPSessionManager *manager = [self manager];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //下载进度
        progress ? progress(downloadProgress) : nil;
        //        NSLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        //        NSLog(@"downloadDir = %@",downloadDir);
        
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        failure && error ? failure(error) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    return downloadTask;
}

+ (PGNetAPIClient *)manager {
    static PGNetAPIClient *manager = NULL;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [PGNetAPIClient sharedClient];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 5.0f;
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    });
    return manager;
}

+(void)timeoutInterval:(NSTimeInterval)timeInterval {
    AFHTTPSessionManager *manager = [self manager];
    manager.requestSerializer.timeoutInterval = timeInterval;
}

+ (void)cancelAllOperations {
    [[self manager].operationQueue cancelAllOperations];
}

+ (NSString *)dictionaryConvertJsonString:(id)parameter {
    NSData *data = [NSJSONSerialization dataWithJSONObject:parameter options:NSJSONWritingPrettyPrinted error:nil];
    NSString *jsonStr = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    return jsonStr;
}

@end
