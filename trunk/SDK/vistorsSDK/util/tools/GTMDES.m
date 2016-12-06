//
//  GTMDES.m
//  53kfiOS
//
//  Created by tanghy on 15/5/25.
//  Copyright (c) 2015年 wenqing. All rights reserved.
//

#import "GTMDES.h"
#import "Util.h"
#define  des_key @"26A025FB51313160C183E4D12479D267"


@implementation GTMDES

+ (NSString *)encryptWithText:(NSString *)sText
{
    //先对数据进行base64
    NSString *text = [GTMBase64 stringByEncodingData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
    //kCCEncrypt 加密
    return [self encrypt:text encryptOrDecrypt:kCCEncrypt key:des_key];
}

+ (NSString *)encryptWithText:(NSString *)sText key:(NSString*)key{
    //先对数据进行base64
    //    NSString *text = [GTMBase64 stringByEncodingData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
    
    //kCCEncrypt 加密
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:key];
    
}



//AES//加密
+ (NSString *)encryptAESWithText:(NSString *)sText key:(NSString*)key{
    //先对数据进行base64
    //    NSString *text = [GTMBase64 stringByEncodingData:[sText dataUsingEncoding:NSUTF8StringEncoding]];
    
    //kCCEncrypt 加密
    return [self encryptAES:sText encryptOrDecrypt:kCCEncrypt key:key];
    
}
+ (NSString *)decryptWithText:(NSString *)sText
{
    //kCCDecrypt 解密
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:des_key];
}

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmDES,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding|kCCOptionECBMode,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeDES,//   DES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding] autorelease];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        //        result = [GTMBase64 stringByEncodingData:data];
        //        result = [[NSString alloc] initWithData:dataOut  encoding:NSUTF8StringEncoding];
        NSString *oriStr = [NSString stringWithFormat:@"%@",data];
        NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
        result = [[oriStr componentsSeparatedByCharactersInSet:cSet] componentsJoinedByString:@""];
    }
    
    return result;
}



+ (NSString *)encryptAES:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)//传递过来的是decrypt 解码
    {
        //解码 base64
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];//转成utf-8并decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  //encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES加密 ：用CCCrypt函数加密一下，然后用base64编码下，传过去
     DES解密 ：把收到的数据根据base64，decode一下，然后再用CCCrypt函数解密，得到原本的数据
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL; //可以理解位type/typedef 的缩写（有效的维护了代码，比如：一个人用int，一个人用long。最好用typedef来定义）
    size_t dataOutAvailable = 0; //size_t  是操作符sizeof返回的结果类型
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);//将已开辟内存空间buffer的首 1 个字节的值设为值 0
    
    NSString *initIv = @"0102030405060708";
    //    const void *vkey = (const void *) [key UTF8String];
    const void *vkey = [[(const void *) [Util alloc]init]addStringLength:key mylength:16 type:0];
    const void *iv = (const void *) [initIv UTF8String];
    
    //CCCrypt函数 加密/解密
    ccStatus = CCCrypt(encryptOperation,//  加密/解密
                       kCCAlgorithmAES128,//  加密根据哪个标准（des，3des，aes。。。。）
                       kCCOptionPKCS7Padding,//  选项分组密码算法(des:对每块分组加一次密  3DES：对每块分组加三个不同的密)
                       vkey,  //密钥    加密和解密的密钥必须一致
                       kCCKeySizeAES256,//   AES 密钥的大小（kCCKeySizeDES=8）
                       iv, //  可选的初始矢量
                       dataIn, // 数据的存储单元
                       dataInLength,// 数据的大小
                       (void *)dataOut,// 用于返回数据
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt)//encryptOperation==1  解码
    {
        //得到解密出来的data数据，改变为utf-8的字符串
        result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding] autorelease];
    }
    else //encryptOperation==0  （加密过程中，把加好密的数据转成base64的）
    {
        //编码 base64
        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        //        result = [GTMBase64 stringByEncodingData:data];
        //        result = [[NSString alloc] initWithData:dataOut  encoding:NSUTF8StringEncoding];
        NSString *oriStr = [NSString stringWithFormat:@"%@",data];
        NSCharacterSet *cSet = [NSCharacterSet characterSetWithCharactersInString:@"< >"];
        result = [[oriStr componentsSeparatedByCharactersInSet:cSet] componentsJoinedByString:@""];
    }
    
    return result;
}

+(void)changLength:(NSString*)str length:(NSString*)length{
    [[[Util alloc]init]addStringLength:str mylength:16 type:48];
    
    //    Byte b = [[str dataUsingEncoding:NSUTF8StringEncoding] bytes];
    //    Byte bb = [[@"0000000000000000" dataUsingEncoding:NSUTF8StringEncoding] bytes];
    //    for (int i=0; i<[b]; <#increment#>) {
    //        <#statements#>
    //    }
    
    
}


+ (NSString *)AES256EncryptWithPlainText:(NSString *)plain key:(NSString*)key{
    NSData *plainText = [plain dataUsingEncoding:NSUTF8StringEncoding];
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    NSUInteger dataLength = [plainText length];
    
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    bzero(buffer, sizeof(buffer));
    
    size_t numBytesEncrypted = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128,kCCOptionPKCS7Padding,
                                          [[[Util alloc]init]addStringLength:key mylength:16 type:0] , kCCKeySizeAES256,
                                          @"0102030405060708" /* initialization vector (optional) */,
                                          [plainText bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *encryptData = [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
        
        return [encryptData base64Encoding];
    }
    
    free(buffer); //free the buffer;
    return nil;
}


@end
