//
//  PGNetworkCache.m
//
//  Created by piggybear on 16/8/22.
//  Copyright © 2016年 piggybear. All rights reserved.
//

#import "PGNetworkCache.h"
#import <CommonCrypto/CommonDigest.h>

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
    [pinCache setObject:responseCache forKey:[self cachedFileNameForKey: key]];
}

+ (id)getResponseCacheForKey:(NSString *)key {
    if (pinCache == nil) {
        pinCache = [PINCache sharedCache];
    }
    return [pinCache objectForKey:[self cachedFileNameForKey: key]];
}

+ (void)removeResponseCacheForKey:(NSString *)key {
    if (pinCache == nil) {
        pinCache = [PINCache sharedCache];
    }
    [pinCache removeObjectForKey:[self cachedFileNameForKey: key]];
}

+ (void)removeAllResponseCache {
    if (pinCache == nil) {
        pinCache = [PINCache sharedCache];
    }
    [pinCache removeAllObjects];
}

+ (NSString *)cachedFileNameForKey:(NSString *)key {
    const char *str = key.UTF8String;
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%@",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10],
                          r[11], r[12], r[13], r[14], r[15], [key.pathExtension isEqualToString:@""] ? @"" : [NSString stringWithFormat:@".%@", key.pathExtension]];
    return filename;
}

@end

