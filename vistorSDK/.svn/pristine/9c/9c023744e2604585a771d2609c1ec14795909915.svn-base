//
//  Util.m
//  53KF
//
//  Created by 53kf on 14-8-11.
//  Copyright (c) 2014年 tanghy. All rights reserved.
//

#import "Util.h"

@implementation Util

static SystemSoundID shake_sound_male_id = 0;

// 从Message转换为data
//+(NSData *)converMessage2Data:(KFSMessage *)message{
//    
//    NSMutableData *param = [[NSMutableData alloc]init];
//    NSString *protocol = @"1.01";
//    int m = 56;
//    short h = 10;
//    NSString *data = [[message getBody]urlencode:[message getBody]];
//    
//    NSInteger len = [data length];
//    protocol = [[message getHeaders] objectForKey:@"protocol"];
//    NSString *from = [[message getHeaders] objectForKey:@"from"];
//    NSString *to = [[message getHeaders] objectForKey:@"to"];
//    NSString *type = [[message getHeaders] objectForKey:@"data_type"];
//    NSString *pageNum = [[message getHeaders] objectForKey:@"packet_num"];
//    
////    NSLog(@"pagenum:%@",pageNum);
//    [param appendBytes:[protocol UTF8String]length:4];
//    [param appendData:[[[self alloc] init] convertInt2Byte:m]];
//    [param appendData:[[[self alloc] init] convertShort2Byte:(short)[type intValue]]];
//    [param appendData:[[[self alloc] init] convertLong2Byte:[pageNum longLongValue]]];
//    [param appendData:[[[self alloc] init] addStringLength:from mylength:16]];
//    [param appendData:[[[self alloc] init] addStringLength:to  mylength:16]];
//    [param appendData:[[[self alloc] init] convertInt2Byte:(int)len]];
//    [param appendData:[[[self alloc] init] convertShort2Byte:h]];
//    [param appendBytes:[data UTF8String] length:[data  length]];
//    return param;
//    
//    
//}
//// 从Message转换为acc所需要的data数据类型
//+(NSData *)converMessage2AccData:(KFSMessage *)message{
//    NSMutableData *param = [[NSMutableData alloc]init];
//   
//    NSString *data = [[message getBody]urlencode:[message getBody]];
////     NSString *data = [message getBody];
//    
//    NSInteger HeadLen = [[[message getHeaders] objectForKey:@"HeadLen"] integerValue];
//    NSInteger Version = [[[message getHeaders] objectForKey:@"Version"] integerValue];
//    NSString *ClientId = [[message getHeaders] objectForKey:@"ClientId"];
//    NSString *PackageId = [[message getHeaders] objectForKey:@"PackageId"];
//    NSString *PackageType = [[message getHeaders] objectForKey:@"PackageType"];
//    NSString *Protocol = [[message getHeaders] objectForKey:@"Protocol"];
//    NSString *State = [[message getHeaders] objectForKey:@"State"];
////    NSInteger BodyLen = [[[message getHeaders] objectForKey:@"BodyLen"]integerValue];
//    NSInteger deviceType = [[[message getHeaders] objectForKey:@"deviceType"]integerValue];
//    
//    [param appendData:[[[self alloc] init] convertInt2Byte:HeadLen]];
//    [param appendData:[[[self alloc] init] convertInt2Byte:Version]];
//    [param appendData:[[[self alloc] init] addStringLength:ClientId mylength:32]];
//    [param appendData:[[[self alloc] init] addStringLength:PackageId mylength:32]];
//    [param appendData:[[[self alloc] init] convertShort2Byte:(short)[PackageType intValue]]];
//    [param appendData:[[[self alloc] init] convertShort2Byte:(short)[Protocol intValue]]];
//    [param appendBytes:[State UTF8String] length:[State length]];
//    [param appendData:[[[self alloc] init] convertInt2Byte:[data  length]]];
//    [param appendData:[[[self alloc] init] convertShort2Byte:(short)deviceType]];
//    [param appendBytes:[data UTF8String] length:[data  length]];
//    return param;
//
//
//}

////从data转换为Message
//+(KFSMessage*) convertData2Message:(NSData*)data{
//    NSInteger totalLength = [data length];
//    NSString *protocol;//协议版本号
//    int protocolLength;//协议头长度
//    short data_type;//协议类型1数据包，2应答包
//    long long pageNum; //数据包编号
//    NSString *from; //消息来源ip
//    NSString *to;   //消息发送地方ip
//    NSString *body; //消息体
//    int bodyLen;    //消息体长度
//    int jiaoyan;   //校验
//    
//    NSMutableData *protocoLen = [[NSMutableData alloc]init];
//    NSMutableData *typeNum = [[NSMutableData alloc]init];
//    NSMutableData *dyan = [[NSMutableData alloc]init];
//    NSMutableData *pageNumTemp = [[NSMutableData alloc]init];
//    NSMutableData *bodyLenTemp = [[NSMutableData alloc]init];
//    
//    
//    //获得protocal信息
//    
//    protocol = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(0,4)]encoding:NSUTF8StringEncoding];
//    //    //获得protocal的长度
//    //    [protocoLen appendData:[data subdataWithRange:NSMakeRange(0,4)]];
//    //     protocolLength = [[[self alloc]init] convertNSData2Int:protocoLen];
//    //获取包长度
//    [protocoLen appendData:[data subdataWithRange:NSMakeRange(4,4)]];
//    protocolLength = [[[self alloc]init] convertNSData2Int:protocoLen];
//    //获取数据包类型
//    [typeNum appendData:[data subdataWithRange:NSMakeRange(8,2)]];
//    data_type = [[[self alloc]init] convertNSData2Short:typeNum];
//    //获取数据包编号
//    [pageNumTemp appendData:[data subdataWithRange:NSMakeRange(10,8)]];
//    pageNum = [[[self alloc]init] convertNSData2Long:pageNumTemp];
//    from =[[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(18, 16)] encoding:NSUTF8StringEncoding];
//    to =[[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(34, 16)] encoding:NSUTF8StringEncoding];
//    //包体长度
//    //获取数据包编号
//    [bodyLenTemp appendData:[data subdataWithRange:NSMakeRange(50,4)]];
//    bodyLen = [[[self alloc]init]convertNSData2Int:bodyLenTemp];
//    //获得校验位 （暂时无用 不用解析）
//    [dyan appendData:[data subdataWithRange:NSMakeRange(54, 2)]];
//    jiaoyan = [[[self alloc]init]convertNSData2Short:dyan];
//    //消息体的长度等于总长度－协议长度
//    long remain = totalLength - protocolLength;
//    //获得消息体
//    
//    body =[[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(56, remain)] encoding:NSUTF8StringEncoding];
//
//    if (body==nil) {
//        body = @"";
//    }
//    NSString *decodeBody  = [body urldecode:body];
////    NSString *decodeBody  = body;
//    NSMutableDictionary *headerContent = [[NSMutableDictionary alloc]init];
//    
//    //把消息转换成message类型返回
//    [headerContent setObject:protocol forKey:@"protocol"];
//    [headerContent setObject:[[NSString alloc]initWithFormat:@"%d",protocolLength] forKey:@"head_length"];
//    [headerContent setObject:[[NSString alloc]initWithFormat:@"%d",data_type] forKey:@"data_type"];
//    [headerContent setObject:[[NSString alloc]initWithFormat:@"%llu",pageNum] forKey:@"packet_num"];
//    [headerContent setObject:[from stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"from"];
//    [headerContent setObject:[to stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] forKey:@"to"];
//    [headerContent setObject:decodeBody forKey:@"body"];
//    [headerContent setObject:[[NSString alloc] initWithFormat:@"%d",jiaoyan] forKey:@"jiaoyan"];
//    KFSMessage *message = [[KFSMessage alloc]init];
//    [message setHeaders:headerContent];
//    [message setBody:decodeBody];
//    return message;
//    
//}
//
//+(KFSMessage*) convertData2ACCMessage:(NSData*)data{
//    
//    NSInteger HeadLen = [[[self alloc]init]convertNSData2Int:[data subdataWithRange:NSMakeRange(0,4)]];
//    NSInteger Version = [[[self alloc]init]convertNSData2Int:[data subdataWithRange:NSMakeRange(4,4)]];
//    NSString *ClientId = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(8, 36)] encoding:NSUTF8StringEncoding];
//    NSString *PackageId = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(44, 36)] encoding:NSUTF8StringEncoding];
//    short PackageType = [[[self alloc]init]convertNSData2Short:[data subdataWithRange:NSMakeRange(80, 2)]];
//    short Protocol = [[[self alloc]init]convertNSData2Short:[data subdataWithRange:NSMakeRange(82, 2)]];
//
//    NSString *State = [[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(84, 2)] encoding:NSUTF8StringEncoding];
//    NSInteger BodyLen = [[[self alloc]init]convertNSData2Int:[data subdataWithRange:NSMakeRange(86,4)]];
//    
//    short deviceType = [[[self alloc]init]convertNSData2Short:[data subdataWithRange:NSMakeRange(90, 2)]];
//    
//    NSString  *body =[[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(92, BodyLen)] encoding:NSUTF8StringEncoding];
//    NSString *decodeBody  = [body urldecode:body];
//    NSMutableDictionary *headerContent = [[NSMutableDictionary alloc]init];
//
//    
//    [headerContent setObject:[NSNumber numberWithInt:HeadLen] forKey:@"HeadLen"];
//    [headerContent setObject:[NSNumber numberWithInt:Version] forKey:@"Version"];
//    [headerContent setObject:ClientId forKey:@"ClientId"];
//    [headerContent setObject:PackageId forKey:@"PackageId"];
//    [headerContent setObject:[NSNumber numberWithShort:PackageType] forKey:@"PackageType"];
//    [headerContent setObject:[NSNumber numberWithShort:Protocol] forKey:@"Protocol"];
//    [headerContent setObject:State forKey:@"State"];
//    [headerContent setObject:[NSNumber numberWithInt:BodyLen] forKey:@"BodyLen"];
//    [headerContent setObject:[NSNumber numberWithInt:deviceType] forKey:@"deviceType"];
//    
//    KFSMessage *message = [[KFSMessage alloc]init];
//    [message setHeaders:headerContent];
//    [message setBody:decodeBody];
//    return message;
//
//}

//把NSData装成short
-(short)convertNSData2Short:(NSData*)data{
    if([data length] == 2){
        Byte *by = (Byte*)[data bytes];
        return (short) ((by[1] & 0xff) | (by[0] & 0xff) << 8);
    }
    return 0;
}

//把NSData转成int
-(int)convertNSData2Int:(NSData*)data{
    if([data length] == 4){
        Byte *by = (Byte*)[data bytes];
        return (by[3] & 0xff) | ((by[2] & 0xff) << 8) | ((by[1] & 0xff) << 16 )| ((by[0] & 0xff) << 24);
    }
    return 0;
}
//把NSdata转成long
-(long long)convertNSData2Long:(NSData*)data{
    if ([data length]==8) {
        Byte *bb = (Byte *)[data bytes];
        return ((((long long) bb[ 0] & 0xff) << 56)
                | (((long long) bb[ 1] & 0xff) << 48)
                | (((long long) bb[ 2] & 0xff) << 40)
                | (((long long) bb[ 3] & 0xff) << 32)
                | (((long long) bb[ 4] & 0xff) << 24)
                | (((long long) bb[ 5] & 0xff) << 16)
                | (((long long) bb[ 6] & 0xff) << 8) | (((long long) bb[ 7] & 0xff) << 0));
    }
    return 0;
}

//把int转成byte
-(NSData*)convertInt2Byte:(int)num{
    NSMutableData *result = [[NSMutableData alloc]init];
    Byte a = (Byte)num;
    Byte b = (Byte)(num >> 8);
    Byte c = (Byte)(num >> 16);
    Byte d = (Byte)(num >> 24);
    [result appendData:[[NSMutableData alloc]initWithBytes:&d length:1]];
    [result appendData:[[NSMutableData alloc]initWithBytes:&c length:1]];
    [result appendData:[[NSMutableData alloc]initWithBytes:&b length:1]];
    [result appendData:[[NSMutableData alloc]initWithBytes:&a length:1]];
    return result;
}

//把long转换成byte
-(NSData*)convertLong2Byte:(long long)data{
//    [NSNumber numberWithLongLong:data]
    NSMutableData *result = [[NSMutableData alloc]init];
    for (int i=0; i<8; i++) {
        int offset =(8 - 1 - i) * 8;
        Byte b = data>>offset;
        [result appendData:[[NSMutableData alloc]initWithBytes:&b length:1]];
    }
    return result;
    
}



///short转成int
-(NSData*)convertShort2Byte:(short)num{
    NSMutableData *result =[[NSMutableData alloc]init];
    Byte a = (Byte)num;
    Byte b = (Byte)(num >> 8);
    [result appendData:[[NSMutableData alloc]initWithBytes:&b length:1]];
    [result appendData:[[NSMutableData alloc]initWithBytes:&a length:1]];
    return result;
}


//补位操作，把所有不满length长度的补空格到length长度
-(NSData*)addStringLength:(NSString*)param mylength:(NSInteger)length{
    NSMutableData *result = [[NSMutableData alloc]init];
    if (![[NSNull null] isEqual:param]) {
         [result appendBytes:[param UTF8String] length:[param length]];
    }
    NSInteger len =[param length];
    NSInteger total = length - len;
    int m=32; //32代表ascii中的space
    for(int i=(int)total;i>0;i--){
        [result appendData:[[NSMutableData alloc]initWithBytes:&m length:1]];
    }
    return result;
}

//获取uuid
+(NSString * )gen_uuid
{
    CFUUIDRef uuid_ref = CFUUIDCreate(NULL);
    CFStringRef uuid_string_ref= CFUUIDCreateString(NULL, uuid_ref);
    
    CFRelease(uuid_ref);
    NSString *uuid = [NSString stringWithString:(__bridge NSString*)uuid_string_ref];
    
    CFRelease(uuid_string_ref);
    return uuid;
}


/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，17，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(17[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    //    NSLog(@"phoneTest is %@",phoneTest);
    return [phoneTest evaluateWithObject:mobile];
}

+(BOOL) isFace:(NSString *)msg{
    NSString *reg = @"(\\[face-)[^\u4e00-\u9fa5]{0,}(\\/\\])";
    NSPredicate *msgTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
    return  [msgTest evaluateWithObject:msg];
}

/**播放音乐*/
+(void)playSoundByName:(NSString*) musicName{
    if (musicName==nil) {
        musicName = @"tritone";
    }
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)[[NSBundle mainBundle]URLForResource:[NSString stringWithFormat:@"%@",musicName] withExtension:@"wav"], &shake_sound_male_id);
    AudioServicesPlaySystemSound(shake_sound_male_id);
}

+(NSString*)replaceStringByReg:(NSString*)regStr msg:(NSString*)msg{
    return [msg stringByReplacingOccurrencesOfRegex:regStr withString:@""];

}

+(long long)getTimeUtil1970{
    double time = [[NSDate date]timeIntervalSince1970]*1000;
    long long rusutTime =  [[NSNumber numberWithDouble:time]longLongValue];
    return rusutTime;
}

+(long long)getTimeByStr:(NSString*)timeStr{
    NSDateFormatter *dateF = [[NSDateFormatter alloc]init];
    NSDateFormatter *dateF2 = [[NSDateFormatter alloc]init];
    [dateF setDateFormat:@"yyyy-MM-dd"];
//    NSDate *thisDate = [NSDate date];
//    [dateF stringFromDate:thisDate];
//    NSString *dataStr = [dateF stringFromDate:[NSDate date]];
    NSString *todyStr = [NSString stringWithFormat:@"%@ %@",[dateF stringFromDate:[NSDate date]],timeStr];
     [dateF2 setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateF2 dateFromString:todyStr];
    long long time = [[NSNumber numberWithDouble:[date timeIntervalSince1970]*1000]longLongValue];
    return time;
//    return 1;
}

+(void)printNsLog:(NSString *)className logStr:(NSString*)logStr{
    BOOL isPrint = YES;
    if(isPrint){
        NSLog(@"类名：%@---- 打印结果：%@",className,logStr);
    }

}


+(NSString*)replaceStringHtmlTag:(NSString *)msg{

    return [[[[[[[[[[[[[[msg stringByReplacingOccurrencesOfString:@"<br/>" withString:@"\n"]stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"]stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"]stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""]stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]stringByReplacingOccurrencesOfString:@"&mdash;" withString:@"-"]stringByReplacingOccurrencesOfString:@"&#039;" withString:@"'"]stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"]stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "]stringByReplacingOccurrencesOfString:@"&copy;" withString:@"©"] stringByReplacingOccurrencesOfString:@"&reg;" withString:@"®"]stringByReplacingOccurrencesOfString:@"&hellip;" withString:@"..."]stringByReplacingOccurrencesOfString:@"&ldquo;" withString:@"“" ]stringByReplacingOccurrencesOfString:@"bdquo" withString:@"”" ];
}

+(id)StringOrDic2NSDic:(NSString*)str{
    if ([str isKindOfClass:[NSString class]]) {
        
        id jsonObj = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
        
        if ([jsonObj isKindOfClass:[NSDictionary class]]) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:jsonObj];
            return  dic;
        }else {
            return jsonObj;
        }
    }
    return str;
}



+(NSString*)dictionary2String:(NSMutableDictionary*)dic{
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
}


+(NSString*)getTimeUtil1970Formater:(NSString*)time{
    double times = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *currentDate =[formatter stringFromDate:date];
    return currentDate;
}



+(NSString *)getNewTimeUtil1970Formater:(NSString *)time
{
    
    
    //原方法今天日期
    double times = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *currentDate =[formatter stringFromDate:date];
    
    
    //今天日期
    NSDate *today=[NSDate date];
    NSString *todayDate =[formatter stringFromDate:today];
    
    
    
    //比较 一样则返回  今天 +时间点
    if ([todayDate isEqualToString:currentDate])
    {
        
        
        [formatter setDateFormat:@"HH:mm"];
        
        NSString *currentDate =[formatter stringFromDate:date];
        
       
        
        NSString* str=[NSString stringWithFormat:@"今天 %@",currentDate];
        
        
        return str;
    }
    else
    {
        //不一样  还是原来的日期
        
        [formatter setDateFormat:@"yyyy-MM-dd"];
        
        NSString *currentDate =[formatter stringFromDate:date];
        
        return currentDate;
        
    }
    
    return nil;
}



//通过url获取搜索引擎
+(NSString*)getSearchEngineByUrl:(NSString*)url{
    if ([url length]>11) {
        NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
        [dic setObject:@"Google" forKey:@"google"];
        [dic setObject:@"Yahoo" forKey:@"yahoo"];
        [dic setObject:@"Sina" forKey:@"iask"];
        [dic setObject:@"Sina" forKey:@"sina"];
        [dic setObject:@"Sogou" forKey:@"sogou"];
        [dic setObject:@"Youdao" forKey:@"youdao"];
        [dic setObject:@"Lycos" forKey:@"lycos"];
        [dic setObject:@"Aol" forKey:@"aol"];
        [dic setObject:@"3721" forKey:@"3721"];
        [dic setObject:@"Search" forKey:@"search"];
        [dic setObject:@"Soso" forKey:@"soso"];
        [dic setObject:@"Zhongsou" forKey:@"zhongsou"];
        [dic setObject:@"Alexa" forKey:@"alexa"];
        [dic setObject:@"Yisou" forKey:@"yisou"];
        [dic setObject:@"Baidu" forKey:@"baidu"];
        [dic setObject:@"Bing" forKey:@"bing"];
        [dic setObject:@"Tom" forKey:@"tom"];
        [dic setObject:@"360" forKey:@"360"];
        [dic setObject:@"360" forKey:@"so"];
        [dic setObject:@"360" forKey:@"haosou"];
        
        [dic setObject:@"Baidu" forKey:@"cpro.baidu.com"];
        [dic setObject:@"Baidu" forKey:@"zhidao.baidu.com"];
        [dic setObject:@"Google" forKey:@"googleads.g.doubleclick.net"];
        
        NSString *str = @"(\\.com(:\\d{1,}){0,1}\\/|\\.cn(:\\d{1,}){0,1}\\/|\\.org(:\\d{1,}){0,1}\\/|\\.com\\.hk(:\\d{1,}){0,1}\\/)";
        NSPredicate *p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(http|https):\\/\\/.*\\.(google\\.com(.*)|google\\.cn(.*)|google\\.com\\.hk(.*)|yahoo\\.com(.*)|iask\\.com(.*)|sina\\.com(.*)|sogou\\.com(.*)|youdao\\.com(.*)|lycos\\.com(.*)|aol\\.com(.*)|3721\\.com(.*)|search\\.com(.*)|soso\\.com(.*)|haosou\\.com(.*)|baidu\\.com(.*)|zhongsou\\.com(.*)|alexa\\.com(.*)|sogou\\.com(.*)|yisou\\.com(.*))"];
        //        p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"(https|http):\\/\\/.*\\.(sogou\\.com(.*))"];
        if ([p evaluateWithObject:url]) {
            return [dic objectForKey:[[self class]insteadCode:url regEx:str code:@""]];
        }
        // 传统百度
        p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http:\\/\\/www\\.(baidu\\.com(:\\d{1,}){0,1}\\/)"];
        if ([p evaluateWithObject:url]) {
            return [dic objectForKey:[[self class]insteadCode:url regEx:str code:@""]];
        }
        // 百度网盟
        p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http:\\/\\/(cpro\\.baidu\\.com(:\\d{1,}){0,1})"];
        if ([p evaluateWithObject:url]) {
            return [dic objectForKey:@"cpro.baidu.com"];
        }
        
        // 百度知道
        p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http:\\/\\/(zhidao\\.baidu\\.com(:\\d{1,}){0,1})"];
        if ([p evaluateWithObject:url]) {
            return [dic objectForKey:@"zhidao.baidu.com"];
        }
        
        // google网盟
        p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http:\\/\\/(googleads\\.g\\.doubleclick\\.net(:\\d{1,}){0,1})"];
        if ([p evaluateWithObject:url]) {
            return [dic objectForKey:@"googleads.g.doubleclick.net"];
        }
        
        // msn
        p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http:\\/\\/cn\\.(bing\\.com(:\\d{1,}){0,1}\\/)"];
        if ([p evaluateWithObject:url]) {
            return [dic objectForKey:[[self class]insteadCode:url regEx:str code:@""]];
        }
        
        
        // tom
        p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http:\\/\\/search\\.(tom\\.com(:\\d{1,}){0,1}\\/)"];
        if ([p evaluateWithObject:url]) {
            NSLog(@"tom");
            return [dic objectForKey:[[self class]insteadCode:url regEx:str code:@""]];
        }
        
        // 360
        p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http:\\/\\/www\\.(so\\.com(:\\d{1,}){0,1}\\/)"];
        if ([p evaluateWithObject:url]) {
            NSLog(@"360");
            return [dic objectForKey:[[self class]insteadCode:url regEx:str code:@""]];
        }
        
        p = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http:\\/\\/so\\.(360\\.cn(:\\d{1,}){0,1}\\/)"];
        if ([p evaluateWithObject:url]) {
            NSLog(@"360");
            return [dic objectForKey:[[self class]insteadCode:url regEx:str code:@""]];
        }
        
    }
    
    return @"";
}


/**
 * insteadCode 将www.baidu.com转化成baidu
 *
 * @param str
 * @param regEx
 * @param code
 * @return 转化好的字符串
 */
+(NSString*)  insteadCode:(NSString*)str regEx:(NSString*)regEx code:(NSString*)code{
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:regEx options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *string = [@"" stringByAppendingString: str];
    NSArray *matches = [regular matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    while ([matches count]>0){
        NSRange Range = [[matches objectAtIndex:0 ] range];
        string = [string substringToIndex:Range.location];
        //         NSString *tagstring = [string substringWithRange:Range];
        //         string = [string stringByReplacingOccurrencesOfString:tagstring withString:code];
        matches = [regular matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    }
    string = [[string stringByReplacingOccurrencesOfString:@"http://" withString:code]stringByReplacingOccurrencesOfString:@"https://" withString:@""];
    NSRange rage = [string rangeOfString:@"." options:NSBackwardsSearch];
    if (rage.length>0) {
        string = [string substringFromIndex:rage.location+1];
    }
    return [string lowercaseString];
}


+(NSString*)replaceHttpUrlTag:(NSString*)str{
    NSString *tag = str;
    if (![str isKindOfClass:[NSString class]]) {
        return str;
    }
    //    1. +  URL 中+号表示空格 %2B
    //    2. 空格 URL中的空格可以用+号或者编码 %20
    //    3. /  分隔目录和子目录 %2F
    //    4. ?  分隔实际的 URL 和参数 %3F
    //    5. % 指定特殊字符 %25
    //    6. # 表示书签 %23
    //    7. & URL 中指定的参数间的分隔符 %26
    //    8. = URL 中指定参数的值 %3D
    tag = [[[[[[[[str stringByReplacingOccurrencesOfString:@"+" withString:@"%2B"]stringByReplacingOccurrencesOfString:@" " withString:@"%20"]stringByReplacingOccurrencesOfString:@"/" withString:@"%2F"]stringByReplacingOccurrencesOfString:@"?" withString:@"%3F"]stringByReplacingOccurrencesOfString:@"%" withString:@"%25"]stringByReplacingOccurrencesOfString:@"#" withString:@"%23"]stringByReplacingOccurrencesOfString:@"&" withString:@"%26"]
           stringByReplacingOccurrencesOfString:@"=" withString:@"%3D"];
    
    return tag;
}

+(NSMutableString *)MD5:(NSString*)secrity
{
    const char *cStr = [secrity UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *resultStr = [NSMutableString string];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [resultStr appendFormat:@"%02x",digest[i]];
    }
    return resultStr;
}

+(NSString*)changeStr2HtmlURL:(NSString*)str{
//    NSString *reg =  @"((((http|ftp|https)://)|)(([a-zA-Z0-9\._-]+\.[a-zA-Z]{2,6})|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,4})*(/[a-zA-Z0-9\&%_\./-~-]*)?)";
    NSString *reg =  @"((((http[s]{0,1}|ftp)://)|)[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)|(www.[a-zA-Z0-9\\.\\-]+\\.([a-zA-Z]{2,4})(:\\d+)?(/[a-zA-Z0-9\\.\\-~!@#$%^&*+?:_/=<>]*)?)";
    
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regular matchesInString:str options:0 range:NSMakeRange(0, [str length])];
    long _indexPath=0;
    NSString *newStr =@"";
    for (int i=0 ;i<[matches count];i++) {
        NSRange Range = [[matches objectAtIndex:i] range];
        if(_indexPath != Range.location){
            newStr = [NSString stringWithFormat:@"%@%@",newStr,[str substringWithRange:NSMakeRange(_indexPath, Range.location-_indexPath)]];
        }
        NSString *url =[[str substringWithRange:Range]rangeOfString:@"http://"].length>0?[str substringWithRange:Range]:[NSString stringWithFormat:@"http://%@",[str substringWithRange:Range]];
        newStr = [NSString stringWithFormat:@"%@[URL=%@]%@[/URL]",newStr,url,[str substringWithRange:Range]];
        _indexPath = Range.location+Range.length;
    }
    return [newStr length]>0?newStr:str;


}

+ (NSString *)stringByDecodingURLFormat:(NSString*)str
{
    NSString *result = [str stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}


@end

