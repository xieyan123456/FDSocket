//
//  MessageManager.m
//  TestApp
//
//  Created by 53kf on 14-8-18.
//  Copyright (c) 2014年 tanghy. All rights reserved.
//

#import "MessageManager.h"
#import "Nationnal.h"
#import "SqliteDB.h"



@implementation MessageManager


static NSString *device_id = nil;


#pragma mark - Buffer服务器



// buffer心跳GET
+ (Message *)getBufGetbody {
    
//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"bufferToken"];
    NSString *token = [Nationnal shareNationnal].token;

    Message *message = [[Message alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"GET" forKey:@"cmd"];
    [dic setObject:[Nationnal shareNationnal].srvid forKey:@"sid"];
    [dic setObject:token forKey:@"token"];
    NSString *body = [Util dictionary2String:dic];//[[[SBJsonWriter alloc] init] stringWithObject:dic];
    
    NSString *packNum = [[NSString alloc] initWithFormat:@"%@", [[[self alloc] init] getPackNum]];
    
    message = [[[[[[message builder] setProtocol:1] setBodyLength:(int)body.length] setPackageId:packNum] setBody:body] build];
    
    return message;
    
}


// bufferAPI
+ (Message *)getBufAPIbody:(NSString*)uuid companyId:(NSString*)companyId{
    
    
    Message *message = [[Message alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"API" forKey:@"cmd"];
    [dic setObject:@"REGG" forKey:@"type"];
    [dic setObject:uuid forKey:@"sid"];
    [dic setObject:companyId forKey:@"companyId"];
    [dic setObject:uuid forKey:@"ip"];
    NSString *body = [Util dictionary2String:dic];//[[[SBJsonWriter alloc] init] stringWithObject:dic];
    
    NSString *packNum = [[NSString alloc] initWithFormat:@"%@", [[[self alloc] init] getPackNum]];
    
    message = [[[[[[message builder] setProtocol:1] setBodyLength:(int)body.length] setPackageId:packNum] setBody:body] build];
    
    return message;
    
}
+ (Message *)getBufLNKbody:(NSString*)companyId groupId:(NSString*)groupId id6d:(NSString*)id6d{
    NSMutableDictionary *guestInfoDic =  [Nationnal shareNationnal].guestInfo;
    Message *message = [[Message alloc] init];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"LNK" forKey:@"cmd"];
    [dic setObject:[guestInfoDic objectForKey:@"styleId"] forKey:@"styleId"];
    [dic setObject:[Nationnal shareNationnal].srvid forKey:@"sid"];
    [dic setObject:companyId forKey:@"companyId"];
    [dic setObject:[Nationnal shareNationnal].token forKey:@"token"];
    
    NSMutableDictionary *argsDic = [[NSMutableDictionary alloc] init];
    
    
    [argsDic setObject:@"{city:\"\",isp:\"\",province:\"\"}" forKey:@"area"];
    [argsDic setObject:[guestInfoDic objectForKey:@"chatNum"] forKey:@"chatNum"];
    [argsDic setObject:@"1" forKey:@"chatStartType"];
    [argsDic setObject:@"" forKey:@"codeUrl"];
    [argsDic setObject:companyId forKey:@"companyId"];
    [argsDic setObject:@"4" forKey:@"consolutionType"];
    [argsDic setObject:@"" forKey:@"from"];
    [argsDic setObject:groupId==nil?@"":groupId forKey:@"groupId"];
    [argsDic setObject:[guestInfoDic objectForKey:@"guestFields"] forKey:@"guestFields"];
    [argsDic setObject:[guestInfoDic objectForKey:@"id"] forKey:@"guestId"];
    [argsDic setObject:[guestInfoDic objectForKey:@"guestInfo"] forKey:@"guestInfo"];
    [argsDic setObject:id6d==nil?@"":id6d forKey:@"id6d"];
    [argsDic setObject:@"" forKey:@"ip"];
    [argsDic setObject:@"" forKey:@"isMini"];
    [argsDic setObject:@"" forKey:@"isuv"];
    [argsDic setObject:@"" forKey:@"keyword"];
    [argsDic setObject:@"IOS" forKey:@"referrer"];
    [argsDic setObject:@"{cn:\"\",en:\"\"}" forKey:@"searchEngine"];
    [argsDic setObject:[guestInfoDic objectForKey:@"styleId"] forKey:@"styleId"];
    [argsDic setObject:@"" forKey:@"themeId"];
    [argsDic setObject:@"" forKey:@"title"];
    [argsDic setObject:@"" forKey:@"url"];
    [argsDic setObject:@"0" forKey:@"visitDuration"];
    [argsDic setObject:[guestInfoDic objectForKey:@"visitNum"] forKey:@"visitNum"];
    if([Nationnal shareNationnal].userInfo != nil){
        [argsDic setObject:[Nationnal shareNationnal].userInfo forKey:@"userInfo"];
    }
    if([Nationnal shareNationnal].userLevel != nil){
        [argsDic setObject:[Nationnal shareNationnal].userLevel forKey:@"userLevel"];
    }
        

    [dic setObject:argsDic forKey:@"args"];
    
    NSString *body = [Util dictionary2String:dic];//[[[SBJsonWriter alloc] init] stringWithObject:dic];
    
    NSString *packNum = [[NSString alloc] initWithFormat:@"%@", [[[self alloc] init] getPackNum]];
    
    message = [[[[[[message builder] setProtocol:1] setBodyLength:(int)body.length] setPackageId:packNum] setBody:body] build];
    
    return message;


}



+ (Message *)getBufTNTbody{
    Message *message = [[Message alloc] init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"TNT" forKey:@"cmd"];
    [dic setObject:[Nationnal shareNationnal].company_id forKey:@"companyId"];
    [dic setObject:[[Nationnal shareNationnal].guestInfo objectForKey:@"styleId"] forKey:@"styleId"];
    [dic setObject:@"kf-all-list" forKey:@"type"];
    
    if (![Nationnal shareNationnal].token) {
        [Nationnal shareNationnal].token = @"";
    }
    
    [dic setObject:[Nationnal shareNationnal].token forKey:@"token"];
    NSString *body = [Util dictionary2String:dic];//[[[SBJsonWriter alloc] init] stringWithObject:dic];
    NSString *packNum = [[NSString alloc] initWithFormat:@"%@", [[[self alloc] init] getPackNum]];
    message = [[[[[[message builder] setProtocol:1] setBodyLength:(int)body.length] setPackageId:packNum] setBody:body] build];
    return message;

}


// buffer结束/转接对话ULN
+ (Message *)getBufULNbody:(NSString *)type {

//    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:@"bufferToken"];
    NSString *token = [Nationnal shareNationnal].token;
    
    Message *message = [[Message alloc] init];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"ULN" forKey:@"cmd"];
    [dic setObject:[Nationnal shareNationnal].chatid forKey:@"chatId"];
    [dic setObject:[Nationnal shareNationnal].srvid forKey:@"sid"];
    [dic setObject:token forKey:@"token"];
    [dic setObject:type forKey:@"type"];
    
    NSString *body = [Util dictionary2String:dic];//[[[SBJsonWriter alloc] init] stringWithObject:dic];
    NSString *packNum = [[NSString alloc] initWithFormat:@"%@", [[[self alloc] init] getPackNum]];
    message = [[[[[[message builder] setProtocol:1] setBodyLength:(int)body.length] setPackageId:packNum] setBody:body] build];
    
    
    return message;
    
}

// buffer发消息
+ (Message *)getBufQSTBody:(NSString *)str type:(NSString*)type packNumber:(NSString*)packNumber isLeave:(BOOL)isLeave{
    Message *message = [[Message alloc] init];
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    if ([type isEqualToString:@"image"]) {
        // 图片类型
        [bodyDic setValue:[Util StringOrDic2NSDic:str] forKey:@"image"];
        
    } else if ([type isEqualToString:@"voice"]) {
        // 音频类型
        [bodyDic setValue:[Util StringOrDic2NSDic:str] forKey:@"voice"];
    } else if([type isEqualToString:@"news"]){
         [bodyDic setValue:[Util StringOrDic2NSDic:str] forKey:@"news"];
    }else{
        // 文本或表情
        type = @"text";
        
    }
    
    [bodyDic setValue:@"QST" forKey:@"cmd"];
    [bodyDic setValue:[Nationnal shareNationnal].srvid forKey:@"sid"];
    [bodyDic setValue:[Nationnal shareNationnal].kfid forKey:@"did"];
    [bodyDic setValue:[Nationnal shareNationnal].chatid==nil?@"":[Nationnal shareNationnal].chatid forKey:@"chatId"];
    [bodyDic setValue:type forKey:@"type"];
    [bodyDic setValue:[Nationnal shareNationnal].token forKey:@"token"];
    [bodyDic setValue:str forKey:@"msg"];
    [bodyDic setValue:[NSNumber numberWithLongLong:[Util getTimeUtil1970]] forKey:@"sort_time"];
    [bodyDic setValue:packNumber forKey:@"packetId"];
    if ([Nationnal shareNationnal].isLeave) {
         NSMutableDictionary *guestInfoDic =  [Nationnal shareNationnal].guestInfo;
        [bodyDic setValue:[Nationnal shareNationnal].company_id forKey:@"companyId"];
        [bodyDic setValue:[guestInfoDic objectForKey:@"styleId"] forKey:@"styleId"];
        [bodyDic setValue:[guestInfoDic objectForKey:@"guestInfo"] forKey:@"guestInfo"];
        [bodyDic setValue:[guestInfoDic objectForKey:@"guestFields"] forKey:@"guestFields"];
        
        NSMutableDictionary *customInfo =  [[NSMutableDictionary alloc] init];
        
        if([Nationnal shareNationnal].userInfo != nil){
            [customInfo setObject:[Nationnal shareNationnal].userInfo forKey:@"userInfo"];
        }
        if([Nationnal shareNationnal].userLevel != nil){
            [customInfo setObject:[Nationnal shareNationnal].userLevel forKey:@"userLevel"];
        }
        [bodyDic setValue:customInfo forKey:@"customInfo"];
    }
    [bodyDic setValue:@"0" forKey:@"issend"];
    [SqliteDB installMessage:bodyDic];
    NSString *body = [Util dictionary2String:bodyDic]; //[[[SBJsonWriter alloc]init]stringWithObject:bodyDic];
//    NSString *packNum = [[NSString alloc] initWithFormat:@"%@", [[[MessageManager alloc] init] getPackNum]];
    message = [[[[[[message builder] setProtocol:1] setBodyLength:(int)body.length] setPackageId:packNumber] setBody:body] build];

    return message;
}


+ (Message *)getBufVOTbody:(NSString *)score voteScore:(NSString *)voteScore response:(BOOL)response{
    NSString *responseStr = @"0";
    if (response) {
        responseStr = @"1";
    }
    Message *message = [[Message alloc] init];
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
   
    
    [bodyDic setValue:@"VOT" forKey:@"cmd"];
    [bodyDic setValue:[Nationnal shareNationnal].srvid forKey:@"id6d"];
    [bodyDic setValue:[Nationnal shareNationnal].company_id forKey:@"companyId"];
    [bodyDic setValue:[Nationnal shareNationnal].chatid forKey:@"chatId"];
    [bodyDic setValue:@"" forKey:@"msg"];
    [bodyDic setValue:[Nationnal shareNationnal].token forKey:@"token"];
    [bodyDic setValue:responseStr forKey:@"response"];
    [bodyDic setValue:score forKey:@"score"];
    [bodyDic setValue:@"vote" forKey:@"type"];
    if (voteScore) {
        [bodyDic setValue:voteScore forKey:@"voteScore"];
    }
    NSString *body = [Util dictionary2String:bodyDic];
    
    NSString *packNum = [[NSString alloc] initWithFormat:@"%@", [[[MessageManager alloc] init] getPackNum]];
    message = [[[[[[message builder] setProtocol:1] setBodyLength:(int)body.length] setPackageId:packNum] setBody:body] build];
    
    return message;





}















//获取数据包编号
-(NSString*)getPackNum{
 
    NSString *timeStr = [[self init]getStringByLength:5];
    return [[@"2" stringByAppendingString:[[NSNumber numberWithLongLong:[[self init]getTimeUtil1970]]stringValue] ]stringByAppendingString:timeStr];
}

//获取制定长度随机数
-(NSString*) getStringByLength:(int)length{
    NSString *strTemp = @"";
    if (length>0) {
        for (int i=0; i<length; i++) {
            int randomNum = arc4random()%10;
            strTemp = [strTemp stringByAppendingString:[[NSNumber numberWithInt:randomNum]stringValue]] ;
        }
    }
    return strTemp;
}
//获取当前时间毫秒数
-(long long)getTimeUtil1970{
    double time = [[NSDate date]timeIntervalSince1970]*1000;
    long long rusutTime =  [[NSNumber numberWithDouble:time]longLongValue];
    return rusutTime;
}

@end
