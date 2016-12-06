//
//  Nationnal.m
//  53kf_iOS
//
//  Created by tagaxi on 14-8-4.
//  Copyright (c) 2014年 Linda. All rights reserved.
//

#import "Nationnal.h"
#import "SendHttpRequest.h"
#import "SqliteDB.h"
static Nationnal* nationnal = nil;
@implementation Nationnal



+(Nationnal*)shareNationnal
{
    if (!nationnal) {
        nationnal = [[Nationnal alloc]init];
        NSArray *pic =  [[NSArray alloc]initWithObjects:@"[困惑]",@"[流泪]",@"[鬼脸]",@"[郁闷]",@"[傲慢]",@"[闭嘴]",@"[惊讶]",@"[流汗]", @"[疑问]",@"[心动]",@"[耍酷]",@"[发怒]",@"[难过]",@"[高兴]",@"[委屈]",@"[鄙视]", @"[瞌睡]",@"[偷笑]",@"[胜利]",@"[再见]",@"[好样]",@"[开心]",@"[鼓掌]",@"[我晕]", @"[握手]",@"[找打]",@"[吃饭]",@"[得意]",@"[好的]",@"[有礼]",@"[惊吓]",@"[发财]", @"[奋斗]",@"[蛋糕]",@"[鲜花]",@"[干杯]",@"[成交]",@"[欢迎]",@"[再会]",@"[通话]",nil];
        NSArray *face =[[NSArray alloc]initWithObjects:@"{53b#1#}",@"{53b#2#}",@"{53b#3#}",@"{53b#4#}",@"{53b#5#}",@"{53b#6#}",@"{53b#7#}",@"{53b#8#}",@"{53b#9#}",@"{53b#10#}",@"{53b#11#}",@"{53b#12#}",@"{53b#13#}",@"{53b#14#}",@"{53b#15#}",@"{53b#16#}",@"{53b#17#}",@"{53b#18#}",@"{53b#19#}",@"{53b#20#}",@"{53b#21#}",@"{53b#22#}",@"{53b#23#}",@"{53b#24#}",@"{53b#25#}",@"{53b#26#}",@"{53b#27#}",@"{53b#28#}",@"{53b#29#}",@"{53b#30#}",@"{53b#31#}",@"{53b#32#}",@"{53b#33#}",@"{53b#34#}",@"{53b#35#}",@"{53b#36#}",@"{53b#37#}",@"{53b#38#}",@"{53b#39#}",@"{53b#40#}",nil];
        nationnal.face2Pic = [NSMutableDictionary dictionaryWithObjects:pic  forKeys:face ];
        nationnal.Pic2face = [NSMutableDictionary dictionaryWithObjects:face  forKeys:pic ];
    }
    return nationnal;
    
}

#pragma mark - 网络是否连接
//检查是否连接网络
+(BOOL)connectedToNetwork {
    // Create zero addy
    struct sockaddr_in zeroAddress;
    bzero(&zeroAddress, sizeof(zeroAddress));
    zeroAddress.sin_len = sizeof(zeroAddress);
    zeroAddress.sin_family = 2;
    
    // Recover reachability flags
    SCNetworkReachabilityRef defaultRouteReachability = SCNetworkReachabilityCreateWithAddress(NULL, (struct sockaddr *)&zeroAddress);
    SCNetworkReachabilityFlags flags;
    
    BOOL didRetrieveFlags = SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags);
    CFRelease(defaultRouteReachability);
    
    if (!didRetrieveFlags)
    {
        return NO;
    }
    
    BOOL isReachable = flags & kSCNetworkFlagsReachable;
    BOOL needsConnection = flags & kSCNetworkFlagsConnectionRequired;
    return (isReachable && !needsConnection) ? YES : NO;
}

+(NSString*)archivePath
{
    NSArray *documents = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *archiverPath = [[documents objectAtIndex:0] stringByAppendingPathComponent:@"nationnal.archiver"];
    return archiverPath;
    
}
-(void)setCompany_id:(NSString *)company_id{
    _company_id = company_id;
    //设置companyid时候获取服务器表情
    NSMutableDictionary *dic = [SendHttpRequest sendHttpRequestWithURL:[NSString  stringWithFormat:@"%@/App/config?companyId=%@",apiUrl,company_id] withData:nil];
    NSMutableDictionary *faceListDic = dic[@"faceList"];
    [SqliteDB executeFaceUpForSQL:@"delete from Face"];
    for (NSString *keyStr in [faceListDic allKeys]) {
        if(![keyStr isEqualToString:@"wechat"]){
            NSString *sql = [NSMutableString stringWithFormat:@"insert into Face (face_id,face_name,face_path,sort,parsing_rules,package_id) values "];
            for(NSDictionary *faceInfo in faceListDic[keyStr]){
                if (![faceInfo[@"parsing_rules"]isKindOfClass:[NSNull class]] && faceInfo[@"parsing_rules"] != nil && [faceInfo[@"parsing_rules"] length]>0) {
                   NSString *temp = [NSString stringWithFormat:@"('%@','%@','%@','%@','%@','%@'),",faceInfo[@"face_id"],faceInfo[@"face_name"],faceInfo[@"face_path"],faceInfo[@"sort"],faceInfo[@"parsing_rules"],faceInfo[@"package_id"]];
                   sql = [sql stringByAppendingString:temp];
                }
            }
            [SqliteDB executeFaceUpForSQL:[sql substringToIndex:[sql length]-1]];
        }
    }
    NSMutableDictionary *packListDic = dic[@"packageList"];
    [SqliteDB cleanPackList];
    for (NSString *keyStr in [packListDic allKeys]) {
        if(![keyStr isEqualToString:@"wechat"]){
            [SqliteDB installPackageList:packListDic[keyStr]];
        }
    }
    _vote = dic[@"vote"];
}

@end
