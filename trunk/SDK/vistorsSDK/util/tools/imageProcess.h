//
//  imageProcess.h
//  53kfiOS
//
//  Created by 53kf on 14-11-24.
//  Copyright (c) 2014年 wenqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@protocol upLoadFileResultDelegate <NSObject>

-(void)uploadPicCallback:(NSString*)result file:(NSData*)file;

@end


@interface imageProcess : NSObject




@property(nonatomic,assign) NSObject<upLoadFileResultDelegate> *upLoadFileCallbackDelegate;


+(void)saveImageToLocation:(NSData*)image imageName:(NSString*)imageName;

+(UIImage*)getUIImageByName:(NSString*)name;

+(NSString*)getTempImageName;


+(UIImage*)getUIImageByURL:(NSString *)url;


+(void) getUIImageForMessage:(NSString*)message completionHandler:(void(^)(UIImage *))complete;

//清理所有下载缓存图片
+(BOOL)deleteAllDownLoadPic;


//获取图片缓存大小
+(long long)getAllDownLoadPicSize;

+(NSString*)getDocumentsPath;

//http上传文件
+(NSString*)UpLoadFileByData:(UIImage*)image;

//http上传图片
-(void)postRequestWithURL: (NSString *)url  // IN
               postParems: (NSMutableDictionary *)postParems // IN
                    image: (UIImage *)image  // IN
              picFileName: (NSString *)picFileName
        completionHandler:(void (^)(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error))completionHandler;
//http上传文件
-(void)postRequestWithURL: (NSString *)url  // IN
               postParems: (NSMutableDictionary *)postParems // IN
                     data: (NSData *)data  // IN
                 fileName: (NSString *)fileName;


//-(void)uploadFileByData:(NSData*)data fileType:(int)ftype  uuid:(NSString*)uuid;
@end
