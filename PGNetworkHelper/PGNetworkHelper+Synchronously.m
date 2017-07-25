//
//  PGNetworkHelper+Synchronously.m
//  AFNetworking
//
//  Created by piggybear on 2017/7/25.
//

#import "PGNetworkHelper+Synchronously.h"

@implementation PGNetworkHelper (Synchronously)
+ (NSURLSessionTask *)synchronouslyGET:(NSString *)URL parameters:(id)parameters cache:(BOOL)cache responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    [self exceptionLogic];
    dispatch_semaphore_t semappore = dispatch_semaphore_create(0);
    NSURLSessionTask *task = [self GET:URL parameters:parameters cache:cache responseCache:responseCache success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
        dispatch_semaphore_signal(semappore);
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        dispatch_semaphore_signal(semappore);
    }];
    dispatch_semaphore_wait(semappore, DISPATCH_TIME_FOREVER);
    return task;
}

+ (NSURLSessionTask *)synchronouslyPOST:(NSString *)URL parameters:(id)parameters cache:(BOOL)cache responseCache:(HttpRequestCache)responseCache success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    [self exceptionLogic];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionTask *task = [self POST:URL parameters:parameters cache:cache responseCache:responseCache success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return task;
}

+ (NSURLSessionTask *)synchronouslyUploadWithURL:(NSString *)URL parameters:(NSDictionary *)parameters images:(NSArray<UIImage *> *)images name:(NSString *)name mimeType:(NSString *)mimeType progress:(HttpProgress)progress success:(HttpRequestSuccess)success failure:(HttpRequestFailed)failure {
    [self exceptionLogic];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionTask *task = [self uploadWithURL:URL parameters:parameters images:images name:name mimeType:mimeType progress:progress success:^(id responseObject) {
        if (success) {
            success(responseObject);
        }
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return task;
}

+ (NSURLSessionTask *)synchronouslyDownloadWithURL:(NSString *)URL fileDir:(NSString *)fileDir progress:(HttpProgress)progress success:(void (^)(NSString *))success failure:(HttpRequestFailed)failure {
    [self exceptionLogic];
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    NSURLSessionTask *task = [self downloadWithURL:URL fileDir:fileDir progress:progress success:^(NSString *filePath) {
        if (success) {
            success(filePath);
        }
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return task;
}

+ (void)exceptionLogic {
    if ([NSThread isMainThread]) {
        if ([self manager].completionQueue == nil || [self manager].completionQueue == dispatch_get_main_queue()) {
            @throw
            [NSException exceptionWithName:NSInvalidArgumentException
                                    reason:@"Can't make a synchronous request on the same queue as the completion handler"
                                  userInfo:nil];
        }
    }
}

@end
