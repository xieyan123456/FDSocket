//
//  KFBufferHelper.h
//  53kfiOS
//
//  Created by tagaxi on 16/3/28.
//  Copyright © 2016年 IncredibleMJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MessageProto.pb.h"
#import <AudioToolbox/AudioToolbox.h>
//#import "MessagePacketCache.h"
#import <AVFoundation/AVFoundation.h>


@interface KFBufferHelper : NSObject

+ (KFBufferHelper*)sharedHelper;
- (void)HelperMessageCenter:(Message*)message;

@end
