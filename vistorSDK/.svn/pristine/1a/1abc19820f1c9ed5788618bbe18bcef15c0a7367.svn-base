//
//  IMSocket.h
//  BaseProject
//
//  Created by Albert on 16/9/13.
//  Copyright © 2016年 IncredibleMJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "Util.h"
#import "MessageProto.pb.h"

@interface IMSocket : GCDAsyncSocket

/**
 *  是否需要重连,退出登录后设置为false
 */
@property (nonatomic,assign) BOOL isNeedReconnect;

/**
 *  socket服务是否有效，即socket已经连接上并且获取了token，[IMSocket sharedSocket].isConnected可获取连接状态，连上不代表拿到了token，所以最好以这个属性来做一些判断
 */
@property (nonatomic,assign,readonly) BOOL isSocketServiceValid;

+ (instancetype)sharedSocket;
+ (instancetype)sharedObject;
+ (void)connect;
- (void)closeSocket;
- (void)sendMessage:(Message *)message;

@end
