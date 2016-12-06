//
//  Util.h
//  53KF
//
//  Created by 53kf on 14-8-11.
//  Copyright (c) 2014年 tanghy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RegexKitLite.h"
#import <AVFoundation/AVFoundation.h>
#import<CommonCrypto/CommonDigest.h>
#import "GTMDES.h"


@interface Util : NSObject

-(NSData*)addStringLength:(NSString*)param mylength:(NSInteger)length;
-(NSData*)convertInt2Byte:(int)num;
-(NSData*)convertShort2Byte:(short)num;
-(NSData*)convertLong2Byte:(long long)num;
-(long long)convertNSData2Long:(NSData*)data;
-(int)convertNSData2Int:(NSData*)data;
-(short)convertNSData2Short:(NSData*)data;

//获取uuid
+(NSString * )gen_uuid;


/*邮箱验证 MODIFIED BY HELENSONG*/
+(BOOL)isValidateEmail:(NSString *)email;

/*手机号码验证 MODIFIED BY HELENSONG*/
+(BOOL) isValidateMobile:(NSString *)mobile;


/*判断是否是自定义表情*/
+(BOOL) isFace:(NSString *)msg;

/**播放音乐*/
+(void)playSoundByName:(NSString*) musicName;

/**根据正则替换*/
+(NSString*)replaceStringByReg:(NSString*)regStr msg:(NSString*)msg;


/**替换特殊字符串*/
+(NSString*)replaceStringHtmlTag:(NSString *)msg;

/**获取当前时间的毫秒数*/
//获取当前时间毫秒数
+(long long)getTimeUtil1970;

+(long long)getTimeByStr:(NSString*)timeStr;

+(void)printNsLog:(NSString *)className logStr:(NSString*)logStr;

+(id)StringOrDic2NSDic:(NSString*)str;

+(NSString*)dictionary2String:(NSMutableDictionary*)dic;

+(NSString*)getTimeUtil1970Formater:(NSString*)time;
+(NSString *)getNewTimeUtil1970Formater:(NSString *)time;//杨写


//通过url获取搜索引擎
+(NSString*)getSearchEngineByUrl:(NSString*)url;

+(NSString*)  insteadCode:(NSString*)str regEx:(NSString*)regEx code:(NSString*)code;


//替换调http请求中各种特殊字符
+(NSString*)replaceHttpUrlTag:(NSString*)str;

//对字符串进行md5加密
+(NSMutableString *)MD5:(NSString*)secrity;

//把普通url转换为pc可以直接点击的url
+(NSString*)changeStr2HtmlURL:(NSString*)str;

+ (NSString *)stringByDecodingURLFormat:(NSString*)str;

@end
