//
//  Nationnal.h
//  53kf_iOS
//
//  Created by tagaxi on 14-8-4.
//  Copyright (c) 2014年 Linda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <netdb.h>
#import <SystemConfiguration/SCNetworkReachability.h>


//一身轻环境
//#define httpUrl @"http://chat.1shen7.com"
//#define tcpUrl @"chat.1shen7.com"
//#define apiUrl @"http://api.1shen7.com"

#define httpUrl @"http://eiisys3_vm_214.nds3.1shen7.com/"
#define tcpUrl @"eiisys3_vm_214.nds3.1shen7.com"
#define apiUrl @"http://eiisys2_vm_214.nds3.1shen7.com/"

//天天果园正式环境
//#define httpUrl @"http://chatoms.fruitday.com"
//#define tcpUrl @"chatoms.fruitday.com"
//#define apiUrl @"http://apioms.fruitday.com"

//天天果园测试环境
//#define httpUrl @"http://chatomstest.fruitday.com"
//#define tcpUrl @"chatomstest.fruitday.com"
//#define apiUrl @"http://apiomstest.fruitday.com"


#define secreKey @"74qe5eMgeW7bcL5h6XYdCxIKwFHDg63b"

#define RedDif [UIColor colorWithRed:232.0/255.0 green:68.0/255.0 blue:36.0/255.0 alpha:1.0f]

#define bgcolor [UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0f]

#define screenWidth  [[UIScreen mainScreen]bounds].size.width
#define screenHeight  [[UIScreen mainScreen]bounds].size.height

@interface Nationnal : NSObject
@property (strong,nonatomic) NSString *company_id,*srvid, *token,*kfid,*chatid;
@property (strong,nonatomic) NSMutableDictionary *face2Pic,*Pic2face,*guestInfo,*roboitInfo,*vote;
@property (assign,nonatomic) BOOL isLogin,isLeave;
+(Nationnal*)shareNationnal;

//会员信息
@property (strong,nonatomic) NSString *userInfo,*userLevel;
@end

