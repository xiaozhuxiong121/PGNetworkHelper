//
//  PGNetworkCache.h
//
//  Created by piggybear on 16/8/22.
//  Copyright © 2016年 piggybear. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - 网络数据缓存类

@interface PGNetworkCache : NSObject

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

@end
