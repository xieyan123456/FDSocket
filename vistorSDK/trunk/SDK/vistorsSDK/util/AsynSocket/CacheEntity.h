//
//  CacheEntity.h
//  TestApp
//
//  Created by 53kf on 14-9-11.
//  Copyright (c) 2014年 tanghy. All rights reserved.


#import <Foundation/Foundation.h>

@interface CacheEntity : NSObject{

    @private NSString *cacheKey;      //缓存包标识id
    @private NSObject *cacheValue;       //缓存的数据
    @private double cacheTimeOut;          //更新时间
    @private Boolean cacheExpired;       //是否终止
    
}

-(void) setCacheEntityValue:(NSString*)key cacheValue:(NSObject*)value cacheTimeOut:(double)timeOut cacheExpired:(Boolean)expired;
-(void) setCacheKey:(NSString*)key;
-(void) setCacheValue:(NSObject*)value;
-(void) setCacheTimeOut:(double)timeOut;
-(void) setCacheExpired:(Boolean)expired;

-(NSString*) getCacheKey;
-(NSObject*) getCacheValue;
-(double) getCacheTimeOut;
-(Boolean) getCacheExpired;
@end
