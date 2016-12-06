//
//  MessageManager.h
//  TestApp
//
//  Created by 53kf on 14-8-18.
//  Copyright (c) 2014年 tanghy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageProto.pb.h"

//typedef NS_ENUM{
//    @"text",
//    @"image",
//    @"voice"
//
//};

@interface MessageManager : NSObject

// buffer获取信息API
+ (Message *)getBufAPIbody:(NSString*)uuid companyId:(NSString*)companyId;


// buffer LNK创建连接
+ (Message *)getBufLNKbody:(NSString*)companyId groupId:(NSString*)groupId id6d:(NSString*)id6d;


// buffer TNT获取配置
+ (Message *)getBufTNTbody;

// buffer心跳GET
+ (Message *)getBufGetbody;

// buffer结束/转接对话ULN
+ (Message *)getBufULNbody:(NSString *)type;

//评分
+ (Message *)getBufVOTbody:(NSString *)score voteScore:(NSString *)voteScore response:(BOOL)response;

// buffer发消息
+ (Message *)getBufQSTBody:(NSString *)str type:(NSString*)type packNumber:(NSString*)packNumber isLeave:(BOOL)isLeave;




//--------------------------华丽的分割线------------------------------------


- (NSString *)getPackNum;

@end
