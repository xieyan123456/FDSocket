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

- (BOOL)isSocketServiceValid {
    return [IMSocket sharedSocket].isConnected && [Nationnal shareNationnal].token;
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
    
    NSLog(@"============didConnectToHost:%@ port:%d",host,port);
    
    [self sendMessage:[MessageManager getBufAPIbody:[Nationnal shareNationnal].srvid  companyId:[Nationnal shareNationnal].company_id]];
    
    [self.reconnectTimer invalidate];
    [self.heartBeatTimer invalidate];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"API" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(sendGetMessage) name:@"API" object:nil];
    
    [sock readDataWithTimeout:-1 tag:100];
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    
    NSLog(@"============socketDidDisconnect");
    
    [self.heartBeatTimer invalidate];
    [self.reconnectTimer invalidate];
    
    if (self.isNeedReconnect) {
        __weak IMSocket *weakSelf = self;
        weakSelf.reconnectTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(reconnect) userInfo:nil repeats:YES];
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    
    NSLog(@"============接收到消息包");
    
    self.didReadDataTime = [[NSDate date]timeIntervalSince1970];
    [self.tempData appendData:data];
    [self processData:_tempData];
    [sock readDataWithTimeout:-1 tag:100];
}

#pragma mark -辅助方法

- (void)reconnect {
    NSLog(@"============重连");
    [IMSocket connect];
}

- (void)heartBeat {
    NSLog(@"============发送心跳包");
    [self sendMessage:[MessageManager getBufGetbody]];
}

- (void)sendMessage:(Message *)message {
    
    NSLog(@"============发送消息:%@",message);
    
    NSData *messageData = [message data];
    NSMutableData *packageData = [[NSMutableData alloc] init];
    [packageData appendData:[[[Util alloc] init] convertInt2Byte:(int)messageData.length]];
    [packageData appendData:messageData];
    [[IMSocket sharedSocket] writeData:packageData withTimeout:-1 tag:0];

}

- (void)sendGetMessage {
    __weak IMSocket *weakSelf = self;
    [self heartBeat];
    weakSelf.heartBeatTimer = [NSTimer scheduledTimerWithTimeInterval:7 target:self selector:@selector(heartBeat) userInfo:nil repeats:YES];
}

- (void)processData:(NSData *)data {
    
    //如果数据小于包头长度,不做处理
    if (data.length < 4) {
        NSLog(@"============数据长度小于4，等待新数据");
        return;
    }
    
    int bodyLength = [[[Util alloc]init] convertNSData2Int:[data subdataWithRange:NSMakeRange(0, 4)]];
    int messageLength = bodyLength + 4;
    
    if (data.length == messageLength) {
        [self receivedCompleteData:data];
        return;
    }
    if (data.length > messageLength) {
        [self receivedExcessData:data];
        return;
    }
    
    NSLog(@"============数据小于完整消息包长度，等待新数据");
    NSLog(@"============数据处理结束");
    
}

- (void)receivedExcessData:(NSData*)data {
    
    NSLog(@"============粘包了");
    
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
    NSLog(@"============收到完整消息包 %@",message);
    [self.messageProcessor HelperMessageCenter:message];
    [_tempData setData:[NSData new]];
    
}

@end
