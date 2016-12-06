//
//  HttpService.m
//  edu
//
//  Created by tanghy on 15/6/11.
//  Copyright (c) 2015年 tanghy. All rights reserved.
//

#import "HttpService.h"

@implementation HttpService

+(NSString*)doHttpPostBySynchronous:(NSString*)uri data:(NSMutableDictionary*)data isMD5:(BOOL)isMD5{
    NSString *requset = @"";
    NSString *requestStr  = @"";
    if (isMD5) {
        [data setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]] forKey:@"once"];
        [data setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]/1000] forKey:@"timestamp"];
    }
    //第一步，创建URL
    if (uri==nil ||[uri isKindOfClass:[NSNull class]]) {
        return requestStr;
    }
    NSURL * URL = [NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString * postString = @"";
    NSMutableArray *keyArr = [[NSMutableArray alloc]init];
    [keyArr addObjectsFromArray:[data allKeys]];
    [keyArr sortUsingSelector:@selector(compare:)];
    for(int i=0 ;i< [keyArr count];i++) {
        NSString *key = [keyArr objectAtIndex:i];
        NSString *val = [Util replaceHttpUrlTag:[data objectForKey:key]];
        NSString *tempStr = [NSString stringWithFormat:@"&%@=%@",key,val];
        if (i==0) {
            tempStr = [NSString stringWithFormat:@"%@=%@",key,val];
        }
        postString = [NSString stringWithFormat:@"%@%@" ,postString,tempStr];
//        i++;
    }
    if (isMD5) {
        if ([postString length]!=0) {
             postString = [postString stringByAppendingString:[NSString stringWithFormat:@"&sign=%@",[Util MD5:[postString stringByAppendingString:secreKey]]]];
        }
    }
    postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    if([postData length]>0){
        [request setHTTPBody:postData];  //设置请求的参数
    }
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
    }else{
        NSLog(@"response : %@",response);
       requset = [[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding];
    }
    return requset ;
}


+(void)doHttpPostByAsynchronous:(NSString*)uri data:(NSMutableDictionary*)data isMD5:(BOOL)isMD5 resultHandler:(void(^)(NSString *resultStr))resultHandler{
    if (isMD5) {
        [data setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]] forKey:@"once"];
        [data setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]/1000] forKey:@"timestamp"];
    }
    
    if (uri==nil ||[uri isKindOfClass:[NSNull class]]) {
        return;
    }
    NSURL *url = [NSURL URLWithString:uri];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
//    NSString *str = @"type=focus-c";
    
    NSString * postString = @"";
    NSMutableArray *keyArr =
    [[NSMutableArray alloc]init];
    [keyArr addObjectsFromArray:[data allKeys]];
    int i = 0;
    [keyArr sortUsingSelector:@selector(compare:)];
    for(NSString *key in keyArr) {
        NSString *val = [Util replaceHttpUrlTag:[data objectForKey:key]];
        NSString *tempStr = [NSString stringWithFormat:@"&%@=%@",key,val];
        if (i==0) {
            tempStr = [NSString stringWithFormat:@"%@=%@",key,val];
        }
        postString = [NSString stringWithFormat:@"%@%@" ,postString,tempStr];
        i++;
    }
    if (isMD5) {
        postString = [postString stringByAppendingString:[NSString stringWithFormat:@"&sign=%@",[Util MD5:[postString stringByAppendingString:secreKey]]]];
        
    }
    postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *requestData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:requestData];
//    return  request;
    //第三步，连接服务器
    
    NSURLConnection *connection = [[NSURLConnection alloc]initWithRequest:request delegate:nil];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue]  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if ([data length] > 0 && connectionError == nil)
            
        {
            
           NSString *str = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
            //操作
            resultHandler(str);
        }
        
        else if ([data length] == 0 && connectionError ==nil)
            
        {
             resultHandler(nil);
            //没有数据
            
        }
        
        else if (connectionError != nil)
            
        {
             resultHandler(nil);
            //超时
            
        }else{
            resultHandler(nil);
        }

    }];
//    return  request;
}

+(NSMutableURLRequest*)doHttpJSONPostByAsynchronous:(NSString*)uri data:(NSMutableDictionary*)data isMD5:(BOOL)isMD5{
      if (uri==nil ||[uri isKindOfClass:[NSNull class]]) {
        return nil;
    }
    NSURL *url = [NSURL URLWithString:uri];
    
    //第二步，创建请求
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url
                                                               cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:10];
    
    [request setHTTPMethod:@"POST"];
    
    
//    NSString * postString = [NSString stringWithFormat:@"[%@]",[[SBJsonWriter alloc]stringWithObject:data]];
     NSString * postString = [Util dictionary2String:data];//[[SBJsonWriter alloc]stringWithObject:data];
    postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData *requestData = [postString dataUsingEncoding:NSUTF8StringEncoding];
    
    [request setHTTPBody:requestData];
    return  request;

}


+(NSString*)doHttpJSONPostBySynchronous:(NSString*)uri data:(NSMutableDictionary*)data isMD5:(BOOL)isMD5{
    NSString *requset = @"";
    NSString *requestStr  = @"";
    if (isMD5) {
        [data setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]] forKey:@"once"];
        [data setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]/1000] forKey:@"timestamp"];
    }
    //第一步，创建URL
    if (uri==nil ||[uri isKindOfClass:[NSNull class]]) {
        return requestStr;
    }
    NSURL * URL = [NSURL URLWithString:[uri stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString * postString = [Util dictionary2String:data];//[[SBJsonWriter alloc]stringWithObject:data];
    postString = [postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSData * postData = [postString dataUsingEncoding:NSUTF8StringEncoding];  //将请求参数字符串转成NSData类型
    
    NSMutableURLRequest * request = [[NSMutableURLRequest alloc]init];
    [request setHTTPMethod:@"post"]; //指定请求方式
    [request setURL:URL]; //设置请求的地址
    [request setHTTPBody:postData];  //设置请求的参数
    
    NSURLResponse * response;
    NSError * error;
    NSData * backData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if (error) {
        NSLog(@"error : %@",[error localizedDescription]);
    }else{
        NSLog(@"response : %@",response);
        requset = [[NSString alloc]initWithData:backData encoding:NSUTF8StringEncoding];
    }
    return requset;

}



@end
