   //
//  AppDelegate.m
//  vistorsSDK
//
//  Created by tanghy on 16/4/11.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "AppDelegate.h"
//#import "ConnBufferService.h"
#import "MessageManager.h"
#import "SendHttpRequest.h"
#import "chat_ViewController.h"
#import "HomeTableViewController.h"
#import "HomeViewController.h"
#import "WebViewController.h"
#import "Util.h"
#import "PMainThreadWatcher.h"

@interface AppDelegate () <UISplitViewControllerDelegate,PMainThreadWatcherDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [[PMainThreadWatcher sharedInstance] startWatch];
//    [PMainThreadWatcher sharedInstance].watchDelegate = self;
    
    self.window = [[UIWindow alloc]initWithFrame:[[UIScreen mainScreen] bounds]];
    NSString *uid = @"213123123124124124";
    NSMutableDictionary *Dic = [SendHttpRequest sendHttpRequestWithURL:[NSString  stringWithFormat:@"%@/guest/guestInfo?companyId=70722519&uid=%@&style=default",httpUrl,uid] withData:nil];
    if ([Dic count]==0) {
        while (YES) {
            Dic = [SendHttpRequest sendHttpRequestWithURL:[NSString  stringWithFormat:@"%@/guest/guestInfo?companyId=70722519&uid=%@&style=default",httpUrl,uid] withData:nil];
            if ([Dic count]!=0) break;
        }
    }
    [Nationnal shareNationnal].guestInfo = Dic;
    [Nationnal shareNationnal].srvid = [Dic objectForKey:@"id"];
    [Nationnal shareNationnal].company_id = @"70722519";
    [Nationnal shareNationnal].isLogin = YES;
    [IMSocket connect];
//    [ConnBufferService connSocket];
    
    
    self.window.backgroundColor = bgcolor;
    [self.window makeKeyAndVisible];
    self.window.rootViewController =  [[HomeViewController alloc]init];//[[UINavigationController alloc]initWithRootViewController:[[WebViewController alloc]init]] ;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];

    return YES;

    
}

//主线程卡顿报告
- (void)onMainThreadSlowStackDetected:(NSArray*)slowStack {
    
    NSLog(@"current thread: %@\n", [NSThread currentThread]);
    
    NSLog(@"===begin printing slow stack===\n");
    for (NSString* call in slowStack) {
        NSLog(@"%@\n", call);
    }
    NSLog(@"===end printing slow stack===\n");
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Split view


@end
