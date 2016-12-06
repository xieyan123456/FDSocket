//
//  SqliteDB.m
//  vistorsSDK
//
//  Created by tanghy on 16/8/2.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "SqliteDB.h"
#import "Util.h"
#import "Nationnal.h"

@implementation SqliteDB

+ (FMDatabaseQueue *)sharedDBQueue {
    NSArray *ducuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *dbPath = [[ducuments objectAtIndex:0] stringByAppendingString:@"/DB.sqlite"];
    
    static FMDatabaseQueue *dbQueue = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"============DB Path:%@",dbPath);
        dbQueue = [[FMDatabaseQueue alloc]initWithPath:dbPath];
        [self createFace:dbQueue];
        [self createMessage:dbQueue];
        [self createPackage:dbQueue];
    });
    
    return dbQueue;
}

+ (void)createMessage:(FMDatabaseQueue *)dbQueue {
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        
        if(![db tableExists:@"Message"]){
            NSString *sql =  @"create table if not exists Message(ID integer primary key,sid text,did text,type text,msg text,time text,chatId text,isread integer default 0,issend integer default 1,markid text)";
            if (![db executeUpdate:sql]) {
                NSLog(@"============Error:%@",[db lastErrorMessage]);
            }
        }
        
        [db close];
    }];

}

+ (void)createFace:(FMDatabaseQueue *)dbQueue {
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        
        if(![db tableExists:@"Face"]){
            NSString *sql =  @"create table if not exists Face(ID integer primary key,face_id text,face_name text,face_path text,sort text,parsing_rules text,package_id text)";
            if (![db executeUpdate:sql]) {
                NSLog(@"============Error:%@",[db lastErrorMessage]);
            }
        }
        
        [db close];
    }];

}

+ (void)createPackage:(FMDatabaseQueue *)dbQueue {
    
    [dbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        
        if(![db tableExists:@"Package"]){
            NSString *sql =  @"create table if not exists Package(ID integer primary key,package_id text,package_name text)";
            if (![db executeUpdate:sql]) {
                NSLog(@"============Error:%@",[db lastErrorMessage]);
            }
        }
        
        [db close];
    }];

}

+ (void)installMessage:(NSMutableDictionary*)msg {
    
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        
        int count = [db intForQuery:@"select count(0) from Message where markid = ? ",msg[@"packetId"]];
        NSString *issend = msg[@"issend"]==nil? @"1": @"0";
        if (count == 0) { //根据当前的毫秒数判断消息是否收到过，作为客户端同一毫秒收到2条消息概率是很低的
            if ([msg[@"type"] isEqualToString:@"image"]) {
                if (msg[@"image"][@"originPath"] != nil) {
                    msg[@"msg"] = msg[@"image"][@"originPath"];
                    issend = @"1";
                }else{
                    issend = @"0";
                }
            }else if ([msg[@"type"] isEqualToString:@"voice"]){
                //                msg[@"msg"] = msg[@"voice"][@"path"];
            }else if ([msg[@"type"] isEqualToString:@"file"]){
                msg[@"msg"] = msg[@"file"][@"path"];
            }else if([msg[@"type"] isEqualToString:@"news"]){
                msg[@"msg"] = [Util dictionary2String:msg[@"news"]];
            }
            NSString *msgStr = msg[@"msg"];
            if (msgStr != nil && ![msgStr isKindOfClass:[NSNull class]] && [msgStr length] >0 ) {
                
                BOOL isSucceed = [db executeUpdate:@"insert into Message(sid,did,msg,type,time,chatId,isread,issend,markid) values(?,?,?,?,?,?,?,?,?)",msg[@"sid"],msg[@"did"],msg[@"msg"],msg[@"type"],msg[@"sort_time"],msg[@"chatId"],@"0",issend,msg[@"packetId"]];
                if (!isSucceed) {
                    NSLog(@"============Error:%@",[db lastErrorMessage]);
                }
                
            }
        }
        
        [db close];
    }];
}

+ (NSMutableArray*)selectAllMessage:(int)page {
    
    __block NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        
        if (page<0) {
            arr = [NSMutableArray array];
        }
        
        int end = page == 0 ? 20 : (page+1)*20;
        FMResultSet *set =  [db executeQuery:[NSString stringWithFormat:@"select * from (select * from Message where sid = '%@' or did = '%@' order by time desc limit %i,%i) order by time asc",[Nationnal shareNationnal].srvid,[Nationnal shareNationnal].srvid,0,end] ];
        while ([set next]) {
            [arr addObject:[set resultDictionary]];
        }
        
        [db close];
    }];

    return arr;
}

+ (void)executeFaceUpForSQL:(NSString*)sql {
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        if (![db executeUpdate:sql]) {
            NSLog(@"============Error:%@",[db lastErrorMessage]);
        }
        [db close];
    }];
}

+ (void)installPackageList:(NSDictionary*)dic {
    
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        
        int count = [db intForQuery:@"select count(0) from Package where package_id = ? ",dic[@"package_id"]];
        if (count == 0) {
            BOOL isSucceed = [db executeUpdate:@"insert into Package(package_id,package_name) values (?,?)",dic[@"package_id"],dic[@"package_name"]];
            if (!isSucceed) {
                NSLog(@"============Error:%@",[db lastErrorMessage]);
            }
        }

        [db close];
    }];
    
}

+ (NSArray*)getPackList {
    
    __block NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        
        FMResultSet *set = [db executeQuery:@"select * from Package"];
        while ([set next]) {
            [arr addObject: [set resultDictionary]];
        }
        
        [db close];
    }];

    return arr;
}

+ (void)cleanPackList {
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        if (![db executeUpdate:@"delete from Package"]) {
            NSLog(@"============Error:%@",[db lastErrorMessage]);
        }
        [db close];
    }];
}

+ (NSArray*)getFaceListByPackId:(NSString*)ID {
    
    __block NSMutableArray *arr = [[NSMutableArray alloc]init];
    
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        
        FMResultSet *set = [db executeQuery:@"select * from Face where package_id = ? ",ID];
        while ([set next]) {
            [arr addObject: [set resultDictionary]];
        }
        
        [db close];
    }];
    
    return arr;
}

+ (NSDictionary*)getFaceByFaceId:(NSString*)ID {
    
    __block NSDictionary *dic = [[NSDictionary alloc]init];
    
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        
        FMResultSet *set = [db executeQuery:@"select * from Face where face_id = ? ",ID];
        while ([set next]) {
            dic = [set resultDictionary];
        }
        
        [db close];
    }];

    return dic;
}

+ (NSDictionary*)getFaceByFaceName:(NSString*)name {
    
    __block NSDictionary *dic = [[NSDictionary alloc]init];
    
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        
        FMResultSet *set = [db executeQuery:@"select * from Face where parsing_rules = ? ",name];
        while ([set next]) {
            dic = [set resultDictionary];
        }
        
        [db close];
    }];
    
    return dic;
}

+ (void)updateOneMessageSendStateWithMarkID:(NSString *)markid {
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        if (![db executeUpdate:@"update Message set issend = 1 where markid = ?",markid]) {
            NSLog(@"============Error:%@",[db lastErrorMessage]);
        }
        [db close];
    }];
}

+ (NSDictionary*)getMessageByMarkid:(NSString *)markid {
    
    __block NSDictionary *dic = [[NSDictionary alloc]init];
    
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        
        FMResultSet *set = [db executeQuery:@"select * from Message where markid = ? ",markid];
        while ([set next]) {
            dic = [set resultDictionary];
        }
        
        [db close];
    }];

    return dic;
}

+ (void)deleteMessageByMarkid:(NSString *)markid {
    [[self sharedDBQueue] inDatabase:^(FMDatabase *db) {
        [db open];
        if (![db executeUpdate:@"delete Message  where markid = ?",markid]) {
            NSLog(@"============Error:%@",[db lastErrorMessage]);
        }
        [db close];
    }];
}

@end
