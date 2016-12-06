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
 *  是否需要掉线重连,退出登录后设置为false
 */
@property (nonatomic,assign) BOOL isNeedReconnect;

+ (instancetype)sharedObject;
+ (void)connect;
- (void)closeSocket;
- (void)sendMessage:(Message *)message;

@end
