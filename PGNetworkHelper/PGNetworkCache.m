//
//  PGNetworkCache.m
//
//  Created by piggybear on 16/8/22.
//  Copyright © 2016年 piggybear. All rights reserved.
//

#import "PGNetworkCache.h"

@implementation PGNetworkCache
static PINCache *pinCache = nil;

+ (void)pathName:(NSString *)name {
  NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject;
    cachePath = [cachePath stringByAppendingPathComponent:@"com.pinterest.PINDiskCache.PINCacheShared"];
    cachePath = [cachePath stringByAppendingPathComponent:name];
   pinCache = [[PINCache sharedCache] initWithName:@"name" rootPath:cachePath];
}

+ (void)saveResponseCache:(id <NSCoding>)responseCache forKey:(NSString *)key {
    if (pinCache == nil) {
        pinCache = [PINCache sharedCache];
    }
    [pinCache setObject:responseCache forKey:key];
}

+ (id)getResponseCacheForKey:(NSString *)key {
    if (pinCache == nil) {
        pinCache = [PINCache sharedCache];
    }
    return [pinCache objectForKey:key];
}

+ (void)removeResponseCacheForKey:(NSString *)key {
    if (pinCache == nil) {
        pinCache = [PINCache sharedCache];
    }
    [pinCache removeObjectForKey:key];
}

+ (void)removeAllResponseCache {
    if (pinCache == nil) {
        pinCache = [PINCache sharedCache];
    }
    [pinCache removeAllObjects];
}

@end

