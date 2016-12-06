//
//  MessagePacketCache.h
//  TestApp
//
//  Created by 53kf on 14-9-15.
//  Copyright (c) 2014年 tanghy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CacheEntity.h"

@interface MessagePacketCache : NSObject

+(MessagePacketCache*) getMessagePacketCacheIntance;



//清除所有缓存
-(void) clearAll;

//判断是否存在
-(Boolean) hasCache:(NSString*)key;

//清除指定缓存
-(void) clearOnly:(NSString*)key;

//载入缓存
-(void) putCache:(NSString*)key cacheValue:(NSObject*)value;


//获取缓存信息
-(CacheEntity*) getCacheInfo:(NSString*)key;

@end
