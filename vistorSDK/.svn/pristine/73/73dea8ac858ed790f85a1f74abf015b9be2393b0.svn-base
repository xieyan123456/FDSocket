//
//  KFBufferHelper.m
//  53kfiOS
//
//  Created by tagaxi on 16/3/28.
//  Copyright © 2016年 IncredibleMJ. All rights reserved.
//

#import "KFBufferHelper.h"
#import "Nationnal.h"
//#import "ConnBufferService.h"
#import "MessagePacketCache.h"
#import "SqliteDB.h"
#import "HttpService.h"

static KFBufferHelper *_bufferHelper;
static BOOL connectStatus = NO;
@implementation KFBufferHelper

+ (KFBufferHelper*)sharedHelper {
    if (!_bufferHelper) {
        _bufferHelper = [[KFBufferHelper alloc]init];
    }
    return _bufferHelper;
}

// 解析数据包 获取cmd值
- (void)HelperMessageCenter:(Message *)message {
    connectStatus = YES;
    NSString *packNum = message.packageId;
    
    if (packNum == nil || [@"" isEqualToString:packNum] || [packNum isKindOfClass: [NSNull class]]) {
        packNum = message.packageId;
        NSLog(@"接收到消息包编号为%@",packNum);
    }

    NSString *command = @"";
    MessagePacketCache *cacheInfo =[MessagePacketCache getMessagePacketCacheIntance];
    if (![cacheInfo hasCache:packNum]) {
        CacheEntity *entity = [[CacheEntity alloc]init];
        double dTime = [[NSDate date]timeIntervalSince1970]*1000;
        [entity setCacheEntityValue:packNum cacheValue:@"" cacheTimeOut:dTime cacheExpired:NO];
        [cacheInfo putCache:packNum cacheValue:entity];
    }else{
        return;
    }
    if([[Util StringOrDic2NSDic:message.body] isKindOfClass:[NSArray class]]){
         NSLog(@"----------------------接收服务器消息为数组时：%@",message.body);
        // 解析消息包, 如果为数组解析数组
        NSArray *arr = [Util StringOrDic2NSDic:message.body];
        for (int i=0; i< [arr count]; i++) {
            command = [[arr objectAtIndex:i]objectForKey:@"cmd"];
            
            if (![cacheInfo hasCache:[arr[i] objectForKey:@"packetId"]]) {
                CacheEntity *entity = [[CacheEntity alloc]init];
                double dTime = [[NSDate date]timeIntervalSince1970]*1000;
                [entity setCacheEntityValue:[arr[i] objectForKey:@"packetId"] cacheValue:@"" cacheTimeOut:dTime cacheExpired:NO];
                [cacheInfo putCache:[arr[i] objectForKey:@"packetId"] cacheValue:entity];
            }else{
                return;
            }
            [self doComandByNotifi:command body:[arr objectAtIndex:i]];
        }

    }else{
        // 不为数组, 解析字典
        NSMutableDictionary *jsonDic = [Util StringOrDic2NSDic:message.body];
        command = [jsonDic objectForKey:@"cmd"];
        [self doComandByNotifi:command body:message.body];
        
    }

}

// 根据cmd命令处理对应的指令
- (void)doComandByNotifi:(NSString*)command body:(NSString*)body{

    NSLog(@"============服务器发送command:%@ body:%@",command,body);
    
    if ([command isEqualToString:@"API"]) {
        // 登陆成功
        NSDictionary *dic = [Util StringOrDic2NSDic:body];
        NSString *token = [dic objectForKey:@"token"];
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        [def setObject:token forKey:@"bufferToken"];
        [Nationnal shareNationnal].token = token;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"API" object:body];
        if([dic[@"hasChat"]intValue] != 0 ){
        
        }
        
    }else if ([command isEqualToString:@"LNK"]) {
        //会话建立
         NSDictionary *dic = [Util StringOrDic2NSDic:body];
        if([[dic objectForKey:@"code"] integerValue]==0){
            [Nationnal shareNationnal].kfid = [[dic objectForKey:@"workerInfo"] objectForKey:@"id6d"];
            [Nationnal shareNationnal].chatid = [dic objectForKey:@"chatId"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LNK" object:dic];
             [Nationnal shareNationnal].isLeave = NO;

        }else if([[dic objectForKey:@"code"] integerValue]==2014){
            //排队
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LNK" object:dic];
        }else if ([[dic objectForKey:@"code"] integerValue]==2009){
            NSMutableDictionary *param = [[NSMutableDictionary alloc] initWithObjectsAndKeys:[Nationnal shareNationnal].company_id,@"companyId",  nil];
            [HttpService doHttpPostByAsynchronous:[NSString stringWithFormat:@"%@/App/LeaveMessage/getLeaveMessageWorker",apiUrl] data:param isMD5:YES resultHandler:^(NSString *resultStr) {
                NSMutableDictionary *workDic =  [Util StringOrDic2NSDic:resultStr];
                [Nationnal shareNationnal].kfid = [[workDic objectForKey:@"detail"] objectForKey:@"id6d"];
                [Nationnal shareNationnal].isLeave = YES;
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LNK" object:dic];
            }];
        
        }
        
    } else if ([command isEqualToString:@"ULN"]) {
        
        // 对话结束
        NSLog(@"接收到ULN命令,消息体内容为%@", body);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ULN" object:body];
        
    } else if ([command isEqualToString:@"QST"]) {
    
        // 发送消息成功
        NSLog(@"发送消息成功,消息体内容为%@", body);
//        [self SaveMessage:body];
        NSDictionary *msg = [Util StringOrDic2NSDic:body];
        if ([[msg objectForKey:@"messageType"] isEqualToString:@"leave"]) {
            NSMutableDictionary *repyDic = [[NSMutableDictionary alloc]init];
            [repyDic setObject:[msg objectForKey:@"cmd"] forKey:@"cmd"];
            [repyDic setObject:[Nationnal shareNationnal].srvid forKey:@"sid"];
            [repyDic setObject:@"2" forKey:@"data_type"];
            [repyDic setObject:@"leave" forKey:@"messageType"];
            [repyDic setObject:[msg objectForKey:@"packetId"] forKey:@"packetId"];
            NSString *repyStr =  [Util dictionary2String:repyDic];//[[SBJsonWriter alloc]stringWithObject:repyDic];
            Message *repyMessage = [[[[[[[[Message alloc] init] builder] setProtocol:1] setBodyLength:(int)repyStr.length] setPackageId:[msg objectForKey:@"packetId"]] setBody:repyStr] build];
            [[IMSocket sharedObject] sendMessage:repyMessage];
            return;
//            [[ConnBufferService connSocket] sendMessage:repyMessage];

        }
        if ([msg[@"data_type"] intValue] == 1) {
            [SqliteDB installMessage:[NSMutableDictionary dictionaryWithDictionary:msg]];
        }
        [[NSNotificationCenter defaultCenter] postNotificationName:@"QST" object:body];
    }else if ([command isEqualToString:@"TNT"]) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"TNT" object:body];
    }else  if ([command isEqualToString:@"VOT"]) {
     [[NSNotificationCenter defaultCenter] postNotificationName:@"VOT" object:body];
    }
    
    //向服务器发送应答包
    NSDictionary *bodyDic = [Util StringOrDic2NSDic:body];
    if ([[bodyDic objectForKey:@"data_type"] intValue] == 2) {
        return;
    }
    
    NSMutableDictionary *repyDic = [[NSMutableDictionary alloc]init];
    [repyDic setObject:[bodyDic objectForKey:@"cmd"] forKey:@"cmd"];
    [repyDic setObject:[Nationnal shareNationnal].srvid forKey:@"sid"];
    [repyDic setObject:@"2" forKey:@"data_type"];
    [repyDic setObject:[bodyDic objectForKey:@"packetId"] forKey:@"packetId"];
    NSString *repyStr = [Util dictionary2String:repyDic];
    Message *repyMessage = [[[[[[Message builder] setProtocol:1] setBodyLength:(int)repyStr.length] setPackageId:[bodyDic objectForKey:@"packetId"]] setBody:repyStr] build];
    [[IMSocket sharedObject] sendMessage:repyMessage];
    
}





@end
