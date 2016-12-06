//
//  imageProcess.m
//  53kfiOS
//
//  Created by 53kf on 14-11-24.
//  Copyright (c) 2014年 wenqing. All rights reserved.
//

#import "imageProcess.h"

@implementation imageProcess

static NSString * const FORM_FLE_INPUT = @"pic";

//保存uiimage类型图片到本地沙盒
+(void)saveImageToLocation:(NSData*)image imageName:(NSString*)imageName{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains( NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSRange index= [imageName rangeOfString:@"/" options:NSBackwardsSearch];
    NSString *folderPath = @"";
    if (index.length>0) {
        folderPath = [imageName substringToIndex:index.location];
    }
    
    folderPath = [NSString stringWithFormat:@"%@/Documents/download_pic/%@",[imageProcess getDocumentsPath],folderPath];
    if (![[NSFileManager defaultManager]isExecutableFileAtPath:folderPath]) {
        BOOL issave =[[NSFileManager defaultManager]createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:nil];
         NSLog(@"是否创建文件夹成功，%c",issave);
    }
    NSString *filePath = [NSString stringWithFormat:@"%@/Documents/download_pic/%@",[imageProcess getDocumentsPath],imageName];
    NSRange rg = [imageName rangeOfString:@"." options:NSBackwardsSearch];
     NSString *newStr = @"png";
    if(rg.length!=0){
        newStr = [imageName substringFromIndex:rg.location+1];
    }
   
    if ([@"png"isEqualToString:newStr]) {
        BOOL issaveImage = [image writeToFile:filePath atomically:YES];
        NSLog(@"是否保存成功，%d",issaveImage);
        
    }else{
        BOOL issaveImage = [image writeToFile:filePath atomically:YES];
        NSLog(@"是否保存成功，%d",issaveImage);
    }

   
//    [UIImageJPEGRepresentation(image,1) writeToFile:path atomically:YES];
}


//通过名称从沙盒内取出图片
+(UIImage*)getUIImageByName:(NSString*)name{
    NSRange rg = [name rangeOfString:@"." options:NSBackwardsSearch];
    if (rg.length==0) {
        name = [NSString stringWithFormat:@"%@.png", name];
    }
    NSString *lPath=[NSString stringWithFormat:@"%@/Documents/download_pic/%@",[imageProcess getDocumentsPath],name];
    UIImage *image =[[UIImage alloc]initWithContentsOfFile:lPath];
    return image;

}


//获取一个临随机数
+(NSString*)getTempImageName{
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式,这里可以设置成自己需要的格式
    [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
    //产生一个随机数
    int radom = (arc4random() % 100);
    //用[NSDate date]可以获取系统当前时间
    NSString *currentDateStr = [dateFormatter stringFromDate:[NSDate date]];
    return [NSString stringWithFormat:@"%@%i",currentDateStr,radom];
    
}

//从网络获取图片
+(UIImage*)getUIImageByURL:(NSString *)url{
    UIImage *image;
    NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    image = [UIImage imageWithData:data];
    return  image;
}



+(void) getUIImageForMessage:(NSString*)message completionHandler:(void(^)(UIImage *))complete{
    __block UIImage *image;
    NSMutableString *path = [NSMutableString stringWithString:message];
    NSRange startRange = [path rangeOfString:@"[IMG]"];
    if (startRange.length>0) {
        [path deleteCharactersInRange:startRange];
    }
    NSRange endRange = [path rangeOfString:@"[/IMG]"];
    if (endRange.length>0) {
        [path deleteCharactersInRange:endRange];
    }
    NSString *filePath = nil;
    NSRange index = [path rangeOfString:@"/" options: NSBackwardsSearch];
    if (index.length>0) {
        NSString *headStr = @"http://mmbiz.qpic.cn/mmbiz/";
        NSString *endstr = @"/0";
        if ([path hasPrefix:headStr]&&[path hasSuffix:endstr]) {
            NSMutableString *filePath0 = [NSMutableString stringWithString:path];
            NSRange range = [filePath0 rangeOfString:headStr];
            [filePath0 deleteCharactersInRange:range];
            NSRange range1 = [filePath0 rangeOfString:endstr];
            [filePath0 deleteCharactersInRange:range1];
            filePath = filePath0;
        }else{
            filePath = [path substringFromIndex:index.location+1];
        }
        image = [imageProcess getUIImageByName:filePath];
    }
    
    if (image) {
        complete(image);
    }else {
        [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:path] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            if (!error) {
                image = [UIImage imageWithData:data];
                complete(image);
            }else {
                complete(nil);
            }
        }];
    }

}

//清理所有下载缓存图片
+(BOOL)deleteAllDownLoadPic{
    BOOL isdelete = NO;
    NSString *dPath=[NSString stringWithFormat:@"%@/Documents/download_pic",[imageProcess getDocumentsPath]];
    if ([[NSFileManager defaultManager]removeItemAtPath:dPath error:nil]) {
        isdelete = YES;
    }
    return  isdelete;
}


//获取图片缓存大小
+(long long)getAllDownLoadPicSize{
    long long picSize = 0;
    NSString *dPath=[NSString stringWithFormat:@"%@/Documents/download_pic",[imageProcess getDocumentsPath]];
    picSize = [[[NSFileManager defaultManager]attributesOfItemAtPath:dPath error:nil]fileSize]/1024;
    return picSize;
}

+(NSString*)getDocumentsPath{
     NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}




+(NSString*)UpLoadFileByData:(UIImage*)image{


        return @"";
}

-(void)postRequestWithURL: (NSString *)url  // IN
               postParems: (NSMutableDictionary *)postParems // IN
                    image: (UIImage *)image  // IN
              picFileName: (NSString *)picFileName
        completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler {
    //    if (postParems==nil) {
    //        postParems = [[NSMutableDictionary alloc]init];
    //    }
    [postParems setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]] forKey:@"once"];
    [postParems setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]/1000] forKey:@"timestamp"];
    [postParems setObject:[Nationnal shareNationnal].token forKey:@"token"];
    NSString * postString = @"";
    NSMutableArray *keyArr =
    [[NSMutableArray alloc]init];
    [keyArr addObjectsFromArray:[postParems allKeys]];
    int i = 0;
    [keyArr sortUsingSelector:@selector(compare:)];
    for(NSString *key in keyArr) {
        NSString *val = [Util replaceHttpUrlTag:[postParems objectForKey:key]];
        NSString *tempStr = [NSString stringWithFormat:@"&%@=%@",key,val];
        if (i==0) {
            tempStr = [NSString stringWithFormat:@"%@=%@",key,val];
        }
        postString = [NSString stringWithFormat:@"%@%@" ,postString,tempStr];
        i++;
    }
    [postParems setObject:[Util MD5:[postString stringByAppendingString:secreKey]] forKey:@"sign"];
//    [NSString stringWithFormat:@"&sign=%@",[Util MD5:[postString stringByAppendingString:secreKey]]]];

    NSString *newURL = url;
    
//    NSString *end = @"\r\n";
    NSString *twoHyphens = @"--";
    NSString *TWITTERFON_FORM_BOUNDARY = @"*****";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
    NSData* data;
    //    if(picFilePath){
    //
    //        UIImage *image=[UIImage imageNamed: picFilePath];
    //    if(image.size.width>200){
    //    image = [[[self class]alloc]imageWithImage:image scaledToSize:CGSizeMake(200, image.size.height*200/image.size.width)];
    //    }
    
    if ((data = UIImageJPEGRepresentation(image, 0.5))) {
        picFileName = [NSString stringWithFormat:@"%@.jpg",picFileName];
    }else {
        data = UIImagePNGRepresentation(image);
        picFileName = [NSString stringWithFormat:@"%@.png",picFileName];
    }
    //    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
//    if(YES){
//        ////添加分界线，换行
//        [body appendFormat:@"%@\r\n",MPboundary];
//        
//        //声明pic字段，文件名为boris.png
//        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
//        //声明上传文件的格式
////        [body appendFormat:@"Content-Type: image/jpge,image/jpg,image/png,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
//    }
    
    //声明结束符：--AaB03x--
//    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n"];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData appendData:[[NSString stringWithFormat:@"%@%@%@",twoHyphens,TWITTERFON_FORM_BOUNDARY,end] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;name=\"pic\";filename=\"%@\"\r\n",picFileName] dataUsingEncoding:NSUTF8StringEncoding]];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
       if(YES){
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[[NSString stringWithFormat:@"%@%@%@",twoHyphens,TWITTERFON_FORM_BOUNDARY,end] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:myRequestData];
    
    [[[NSURLSession sharedSession] dataTaskWithRequest:request completionHandler:completionHandler] resume];
}

-(void)postRequestWithURL: (NSString *)url  // IN
               postParems: (NSMutableDictionary *)postParems // IN
                    data: (NSData *)data  // IN
              fileName: (NSString *)fileName{
    
    [postParems setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]] forKey:@"once"];
    [postParems setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]/1000] forKey:@"timestamp"];
    [postParems setObject:[Nationnal shareNationnal].token forKey:@"token"];
    NSString * postString = @"";
    NSMutableArray *keyArr =
    [[NSMutableArray alloc]init];
    [keyArr addObjectsFromArray:[postParems allKeys]];
    int i = 0;
    [keyArr sortUsingSelector:@selector(compare:)];
    for(NSString *key in keyArr) {
        NSString *val = [Util replaceHttpUrlTag:[postParems objectForKey:key]];
        NSString *tempStr = [NSString stringWithFormat:@"&%@=%@",key,val];
        if (i==0) {
            tempStr = [NSString stringWithFormat:@"%@=%@",key,val];
        }
        postString = [NSString stringWithFormat:@"%@%@" ,postString,tempStr];
        i++;
    }
    [postParems setObject:[Util MD5:[postString stringByAppendingString:secreKey]] forKey:@"sign"];
    //    [NSString stringWithFormat:@"&sign=%@",[Util MD5:[postString stringByAppendingString:secreKey]]]];
    
    NSString *newURL = url;
    
    //    NSString *end = @"\r\n";
    NSString *twoHyphens = @"--";
    NSString *TWITTERFON_FORM_BOUNDARY = @"*****";
    //根据url初始化request
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:newURL]
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:10];
    //分界线 --AaB03x
    NSString *MPboundary=[[NSString alloc]initWithFormat:@"--%@",TWITTERFON_FORM_BOUNDARY];
    //结束符 AaB03x--
    NSString *endMPboundary=[[NSString alloc]initWithFormat:@"%@--",MPboundary];
    //得到图片的data
//    NSData* data;
//    //    if(picFilePath){
//    //
//    //        UIImage *image=[UIImage imageNamed: picFilePath];
//    if(image.size.width>200){
//        image = [[[self class]alloc]imageWithImage:image scaledToSize:CGSizeMake(200, image.size.height*200/image.size.width)];
//    }
//    //判断图片是不是png格式的文件
//    if (UIImagePNGRepresentation(image)) {
//        //返回为png图像。
//        picFileName = [NSString stringWithFormat:@"%@.png",picFileName];
//        data = UIImagePNGRepresentation(image);
//    }else {
//        //返回为JPEG图像。
//        picFileName = [NSString stringWithFormat:@"%@.jpg",picFileName];
//        data = UIImageJPEGRepresentation(image, 1.0);
//    }
    //    }
    //http body的字符串
    NSMutableString *body=[[NSMutableString alloc]init];
    //参数的集合的所有key的集合
    NSArray *keys= [postParems allKeys];
    
    //遍历keys
    for(int i=0;i<[keys count];i++)
    {
        //得到当前key
        NSString *key=[keys objectAtIndex:i];
        
        //添加分界线，换行
        [body appendFormat:@"%@\r\n",MPboundary];
        //添加字段名称，换2行
        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n",key];
        //添加字段的值
        [body appendFormat:@"%@\r\n",[postParems objectForKey:key]];
        
        NSLog(@"添加字段的值==%@",[postParems objectForKey:key]);
    }
    
    //    if(YES){
    //        ////添加分界线，换行
    //        [body appendFormat:@"%@\r\n",MPboundary];
    //
    //        //声明pic字段，文件名为boris.png
    //        [body appendFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n",FORM_FLE_INPUT,picFileName];
    //        //声明上传文件的格式
    ////        [body appendFormat:@"Content-Type: image/jpge,image/jpg,image/png,image/gif, image/jpeg, image/pjpeg, image/pjpeg\r\n\r\n"];
    //    }
    
    //声明结束符：--AaB03x--
    //    NSString *end=[[NSString alloc]initWithFormat:@"\r\n%@",endMPboundary];
    NSString *end=[[NSString alloc]initWithFormat:@"\r\n"];
    //声明myRequestData，用来放入http body
    NSMutableData *myRequestData=[NSMutableData data];
    //将body字符串转化为UTF8格式的二进制
    [myRequestData appendData:[body dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData appendData:[[NSString stringWithFormat:@"%@%@%@",twoHyphens,TWITTERFON_FORM_BOUNDARY,end] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data;name=\"pic\";filename=\"%@\"\r\n",fileName] dataUsingEncoding:NSUTF8StringEncoding]];
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    if(YES){
        //将image的data加入
        [myRequestData appendData:data];
    }
    //加入结束符--AaB03x--
    [myRequestData appendData:[end dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[[NSString stringWithFormat:@"%@%@%@",twoHyphens,TWITTERFON_FORM_BOUNDARY,end] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"Keep-Alive" forHTTPHeaderField:@"Connection"];
    [request setValue:@"UTF-8" forHTTPHeaderField:@"Charset"];
    //设置HTTPHeader中Content-Type的值
    NSString *content=[[NSString alloc]initWithFormat:@"multipart/form-data; boundary=%@",TWITTERFON_FORM_BOUNDARY];
    [request setValue:content forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:myRequestData];
    
    
    
    NSHTTPURLResponse *urlResponese = nil;
    NSError *error = [[NSError alloc]init];
    NSData* resultData = [NSURLConnection sendSynchronousRequest:request   returningResponse:&urlResponese error:&error];
    NSString* result= [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
    if([urlResponese statusCode] >=200&&[urlResponese statusCode]<300){
        NSLog(@"返回结果=====%@",result);
        [self.upLoadFileCallbackDelegate uploadPicCallback:result file:data];
    }else{
        [self.upLoadFileCallbackDelegate uploadPicCallback:nil file:data];
    }
}



-(NSString *)decodeFromPercentEscapeString:(NSString *)input {
    NSMutableString *outputStr = [NSMutableString stringWithString:input];
    [outputStr replaceOccurrencesOfString:@"+" withString:@" " options:NSLiteralSearch range:NSMakeRange(0, [outputStr length])];
     
     return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

//对图片尺寸进行压缩--
-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end
