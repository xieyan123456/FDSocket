//
//  IMSocket.m
//  BaseProject
//
//  Created by Albert on 16/9/13.
//  Copyright © 2016年 IncredibleMJ. All rights reserved.
//

#import "IMSocket.h"
#import "KFBufferHelper.h"
#import "MessageManager.h"
#import "MessagePacketCache.h"

@import BlocksKit;

@interface IMSocket ()<GCDAsyncSocketDelegate>

@property (nonatomic,strong) NSMutableData *tempData;
@property (nonatomic,strong) KFBufferHelper *messageProcessor;
@property (nonatomic,strong) NSTimer *heartBeatTimer;
@property (nonatomic,strong) NSTimer *reconnectTimer;
@property (nonatomic,assign) NSTimeInterval didReadDataTime;

@end

@implementation IMSocket

- (NSMutableData *)tempData {
    if (!_tempData) {
        _tempData = [NSMutableData new];
    }
    return _tempData;
}

- (KFBufferHelper *)messageProcessor {
    if (!_messageProcessor) {
        _messageProcessor = [KFBufferHelper sharedHelper];
    }
    return _messageProcessor;
}

+ (instancetype)sharedObject {
    static IMSocket *obj = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        obj = [IMSocket new];
        obj.isNeedReconnect = true;
    });
    return obj;
}

+ (instancetype)sharedSocket {
    static IMSocket *_socket = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _socket = [[IMSocket alloc]initWithDelegate:[IMSocket sharedObject] delegateQueue:dispatch_get_main_queue()];
    });
    return _socket;
}

+ (void)connect {
    if ([[IMSocket sharedSocket] isConnected]) {
        return;
    }
    NSError *error = nil;
    [[IMSocket sharedSocket] connectToHost:tcpUrl onPort:8080 error:&error];
    if (error) {
        NSLog(@"%@",error);
    }
}

- (void)closeSocket {
    [IMSocket sharedObject].isNeedReconnect = false;
    [[IMSocket sharedSocket] disconnect];
}

#pragma mark -GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    
    [self sendMessage:[MessageManager getBufAPIbody:[Nationnal shareNationnal].srvid  companyId:[Nationnal shareNationnal].company_id]];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"API" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendGetMessage) name:@"API" object:nil];
    
    [self.reconnectTimer invalidate];
    
    [sock readDataWithTimeout:-1 tag:100];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    [self.heartBeatTimer invalidate];
    
    if (self.isNeedReconnect) {
        self.reconnectTimer = [NSTimer bk_scheduleTimerWithTimeInterval:5 repeats:true usingBlock:^(NSTimer * _Nonnull timer) {
            [IMSocket connect];
        }];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    self.didReadDataTime = [[NSDate date]timeIntervalSince1970];
    [self.tempData appendData:data];
    [self processData:_tempData];
    [sock readDataWithTimeout:-1 tag:100];
}

#pragma mark -辅助方法

- (void)sendMessage:(Message *)message {
    
    NSData *messageData = [message data];
    NSMutableData *packageData = [[NSMutableData alloc] init];
    [packageData appendData:[[[Util alloc] init] convertInt2Byte:(int)messageData.length]];
    [packageData appendData:messageData];
    [[IMSocket sharedSocket] writeData:packageData withTimeout:-1 tag:0];

}

- (void)sendGetMessage {
    self.heartBeatTimer = [NSTimer bk_scheduleTimerWithTimeInterval:7 repeats:true usingBlock:^(NSTimer * _Nonnull timer) {
        if ([[NSDate date]timeIntervalSince1970] - self.didReadDataTime > 20) {
            [self sendMessage:[MessageManager getBufGetbody]];
        }
    }];
}

- (void)processData:(NSData *)data {
    
    //如果数据小于包头长度,不做处理
    if (data.length < 4) {
        return;
    }
    
    int bodyLength = [[[Util alloc]init] convertNSData2Int:[data subdataWithRange:NSMakeRange(0, 4)]];
    int messageLength = bodyLength + 4;
    
    if (data.length == messageLength) {
        [self receivedCompleteData:data];
    }
    if (data.length > messageLength) {
        [self receivedExcessData:data];
    }

}

- (void)receivedExcessData:(NSData*)data {
    
    //粘包处理时防止原始数据被更改，拷贝一下
    data = [data copy];
    
    int bodyLength = [[Util new] convertNSData2Int:[data subdataWithRange:NSMakeRange(0, 4)]];
    int messageLength = bodyLength + 4;
    
    NSData *completeData = [data subdataWithRange:NSMakeRange(0, messageLength)];
    [self receivedCompleteData:completeData];
    
    if (data.length > messageLength) {
        NSData *remainData = [data subdataWithRange:NSMakeRange(messageLength, [data length] - messageLength)];
        [_tempData setData:remainData];
        [self processData:_tempData];
    }
    
}

- (void)receivedCompleteData:(NSData*)data {

    int bodyLength = [[Util new] convertNSData2Int:[data subdataWithRange:NSMakeRange(0, 4)]];
    Message *message = [Message parseFromData:[data subdataWithRange:NSMakeRange(4, bodyLength)]];
    
    NSDictionary *bodyDic = [Util StringOrDic2NSDic:message.body];
    
    if ([[bodyDic objectForKey:@"data_type"] intValue]==1) {
        MessagePacketCache *cacheInfo =[MessagePacketCache getMessagePacketCacheIntance];
        if ([cacheInfo hasCache:message.packageId ]){
            return;
        }
        
        //向服务器发送应答包
        NSMutableDictionary *repyDic = [[NSMutableDictionary alloc]init];
        [repyDic setObject:[bodyDic objectForKey:@"cmd"] forKey:@"cmd"];
        [repyDic setObject:[Nationnal shareNationnal].srvid forKey:@"sid"];
        [repyDic setObject:@"2" forKey:@"data_type"];
        [repyDic setObject:[bodyDic objectForKey:@"packetId"] forKey:@"packetId"];
        NSString *repyStr = [Util dictionary2String:repyDic];
        Message *repyMessage = [[[[[[message builder] setProtocol:1] setBodyLength:(int)repyStr.length] setPackageId:message.packageId] setBody:repyStr] build];
        [self sendMessage:repyMessage];
        
        [self.messageProcessor HelperMessageCenter:message];
        
    }

    [_tempData setData:[NSData new]];
    
}

@end
