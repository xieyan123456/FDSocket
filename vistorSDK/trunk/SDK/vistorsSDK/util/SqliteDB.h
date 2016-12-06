//
//  SqliteDB.h
//  vistorsSDK
//
//  Created by tanghy on 16/8/2.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface SqliteDB : NSObject

+ (FMDatabaseQueue *)sharedDBQueue;

+ (void)cleanPackList;
+ (void)installMessage:(NSMutableDictionary*)msg;
+ (NSMutableArray*)selectAllMessage:(int)page;
+ (void)executeFaceUpForSQL:(NSString*)sql;
+ (void)installPackageList:(NSDictionary*)dic;
+ (NSArray*)getPackList;
+ (NSArray*)getFaceListByPackId:(NSString*)ID;
+ (NSDictionary*)getFaceByFaceId:(NSString*)ID;
+ (NSDictionary*)getFaceByFaceName:(NSString*)name;
+ (void)updateOneMessageSendStateWithMarkID:(NSString *)markid;
+ (NSDictionary*)getMessageByMarkid:(NSString *)markid;
+ (void)deleteMessageByMarkid:(NSString *)markid;

@end
