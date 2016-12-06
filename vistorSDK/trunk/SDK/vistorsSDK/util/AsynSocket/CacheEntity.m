//
//  CacheEntity.m
//  TestApp
//
//  Created by 53kf on 14-9-11.
//  Copyright (c) 2014年 tanghy. All rights reserved.
//

#import "CacheEntity.h"

@implementation CacheEntity


-(void) setCacheEntityValue:(NSString*)key cacheValue:(NSObject*)value cacheTimeOut:(double)timeOut cacheExpired:(Boolean)expired{
    cacheKey = key;
    cacheValue = value;
    cacheTimeOut = timeOut;
    cacheExpired = expired;

}
-(void) setCacheKey:(NSString*)key{
    cacheKey = key;
}
-(void) setCacheValue:(NSObject*)value{
    cacheValue = value;
}
-(void) setCacheTimeOut:(double)timeOut{
    cacheTimeOut = timeOut;
}
-(void) setCacheExpired:(Boolean)expired{
    cacheExpired = expired;
}

-(NSString*) getCacheKey{
    return cacheKey;
}
-(NSObject*) getCacheValue{
    return cacheValue;
    
}
-(double) getCacheTimeOut{
    return cacheTimeOut;
}
-(Boolean) getCacheExpired{
    return cacheExpired;
}

@end
