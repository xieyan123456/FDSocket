//
//  GTMDES.h
//  53kfiOS
//
//  Created by tanghy on 15/5/25.
//  Copyright (c) 2015年 wenqing. All rights reserved.
//

#import <Foundation/Foundation.h>
#import"GTMBase64.h"
#import<CommonCrypto/CommonCryptor.h>

@interface GTMDES : NSObject



+ (NSString *)encryptWithText:(NSString *)sText;//加密
+ (NSString *)encryptWithText:(NSString *)sText key:(NSString*)key;//加密

//AES
+ (NSString *)encryptAESWithText:(NSString *)sText key:(NSString*)key;//加密
+ (NSString *)AES256EncryptWithPlainText:(NSString *)plain key:(NSString*)key;




+ (NSString *)decryptWithText:(NSString *)sText;//解密
+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key;

+(void)changLength:(NSString*)str length:(NSString*)length;


@end
