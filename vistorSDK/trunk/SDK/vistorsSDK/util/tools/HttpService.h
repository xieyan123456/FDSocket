//
//  HttpService.h
//  edu
//
//  Created by tanghy on 15/6/11.
//  Copyright (c) 2015年 tanghy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HttpService : NSObject

+(NSString*)doHttpPostBySynchronous:(NSString*)uri data:(NSMutableDictionary*)data isMD5:(BOOL)isMD5;


+(void)doHttpPostByAsynchronous:(NSString*)uri data:(NSMutableDictionary*)data isMD5:(BOOL)isMD5 resultHandler:(void(^)(NSString *resultStr))resultHandler;


+(NSMutableURLRequest*)doHttpJSONPostByAsynchronous:(NSString*)uri data:(NSMutableDictionary*)data isMD5:(BOOL)isMD5;

+(NSString*)doHttpJSONPostBySynchronous:(NSString*)uri data:(NSMutableDictionary*)data isMD5:(BOOL)isMD5;


@end
