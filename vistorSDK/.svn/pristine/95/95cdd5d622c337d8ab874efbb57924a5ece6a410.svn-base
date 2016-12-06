//
//  MessagePacketCache.m
//  TestApp
//
//  Created by 53kf on 14-9-15.
//  Copyright (c) 2014年 tanghy. All rights reserved.
//

#import "MessagePacketCache.h"

static  NSMutableDictionary *cacheDic;
MessagePacketCache *messagePacketCache;


@implementation MessagePacketCache
  //= [NSMusicDirectory a];
+(MessagePacketCache*) getMessagePacketCacheIntance{
    if (messagePacketCache==nil) {
        messagePacketCache = [[MessagePacketCache alloc]init];
        cacheDic = [[NSMutableDictionary alloc]init];
    }
    return messagePacketCache;
}

//清除所有缓存
-(void) clearAll{
    if (cacheDic!=nil) {
       @synchronized(self){
        [cacheDic removeAllObjects];
       }
    }

}

//判断是否存在
-(Boolean) hasCache:(NSString*)key{
    if (cacheDic!=nil) {
        NSObject *val=[cacheDic  objectForKey:key];
        if (val!=nil) {
            return YES;
        }
        return NO;
    }
    return  NO;
}

//清除指定缓存
-(void) clearOnly:(NSString*)key{
    if (cacheDic!=nil) {
        @synchronized(self){
             [cacheDic removeObjectForKey:key];
        }
       
    }

}

//载入缓存
-(void) putCache:(NSString*)key cacheValue:(NSObject*)value{
    @synchronized(self){
        [cacheDic setObject:value forKey:key];
        [[self init]clearOutTimeCache];
    }
}


//获取缓存信息
-(CacheEntity*) getCacheInfo:(NSString*)key{
    if ([[ self init]hasCache:key]) {
        return [cacheDic objectForKey:key];
    }else{
        return nil;
    }

}

//清除超时数据
-(void) clearOutTimeCache{
    @synchronized(self){
        double nowTime = [[NSDate date]timeIntervalSince1970]*1000;
        if ([cacheDic count]>0) {
           NSArray *allKey = [cacheDic allKeys];
            for (int i=0;i< [allKey count];i++) {
                NSString *oneKey = [allKey objectAtIndex:i];
                CacheEntity *entity = [cacheDic objectForKey:oneKey];
                double cacheOutTime = [entity getCacheTimeOut];
                if (nowTime-cacheOutTime>300*1000) {
                    [cacheDic removeObjectForKey:oneKey];
                }
            }
        }
    }
}

@end
