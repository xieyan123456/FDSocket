//
//  SendHttpRequest.m
//  53kf_iOS
//
//  Created by tagaxi on 14-8-4.
//  Copyright (c) 2014年 Linda. All rights reserved.
//

#import "SendHttpRequest.h"

@implementation SendHttpRequest
+(NSMutableDictionary*)sendHttpRequestWithURL:(NSString*)urlStr withData:(NSString*)dataStr
{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"GET"];
    dataStr = [dataStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *receivedStr = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
//    [Util StringOrDic2NSDic:receivedStr]
//    NSMutableDictionary *Result = [[NSMutableDictionary alloc]initWithDictionary:[receivedStr json2dictionay:receivedStr]];
    
    return  [Util StringOrDic2NSDic:receivedStr];

  
}

+(NSMutableDictionary*)sendHttpRequestQuesWithURL:(NSString*)urlStr withData:(NSString*)dataStr {
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    [request setHTTPMethod:@"POST"];
    dataStr = [dataStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:data];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *receivedStr = [[NSString alloc]initWithData:received encoding:NSUTF8StringEncoding];
    NSString *result = [receivedStr stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    result = [result stringByReplacingOccurrencesOfString:@"=" withString:@"\":\""];
    
    result = [result stringByReplacingOccurrencesOfString:@"{" withString:@"{\""];
    result = [result stringByReplacingOccurrencesOfString:@"}" withString:@"\"}"];
    result = [result stringByReplacingOccurrencesOfString:@", " withString:@"\", \""];
    
//    NSMutableDictionary *Result = [[NSMutableDictionary alloc]initWithDictionary:[result json2dictionay:result]];
    
    
    return  [Util StringOrDic2NSDic:result];
}

+ (NSMutableDictionary *)sendHttpRequestGetWithURL:(NSString *)urlStr withData:(NSString *)dataStr {
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@?%@", urlStr, dataStr]];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    NSData *received = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSMutableDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:received options:NSJSONReadingMutableContainers error:nil];
    
    return dataDic;
    
}

@end
