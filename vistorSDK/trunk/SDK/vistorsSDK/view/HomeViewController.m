//
//  HomeViewController.m
//  vistorsSDK
//
//  Created by tanghy on 16/5/16.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "HomeViewController.h"
#import "WebViewController.h"
#import "HomeTableViewController.h"
#import "RobotViewController.h"

@interface HomeViewController ()<UITabBarControllerDelegate>

@property(nonatomic,strong)UINavigationController *nav1,*nav2,*nav3,*nav4;

@end

@implementation HomeViewController

{
    WebViewController *web;
    HomeTableViewController *home;
    RobotViewController *robot;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    web = [[WebViewController alloc]init];
    _nav1 = [[UINavigationController alloc]initWithRootViewController:web];
    _nav1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"主页" image:[UIImage imageNamed:@"home_unselect"] tag:1004];
    _nav1.tabBarItem.selectedImage =  [[UIImage imageNamed:@"home_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    home = [[HomeTableViewController alloc]init];
    _nav2 = [[UINavigationController alloc]initWithRootViewController:home];
    _nav2.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"客服" image:[UIImage imageNamed:@"kf_list_unselect"] tag:1005];
    _nav2.tabBarItem.selectedImage =  [[UIImage imageNamed:@"kf_list_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
//    robot = [[RobotViewController alloc]init];
//    robot.isChat = YES;
//    _nav3 = [[UINavigationController alloc]initWithRootViewController:robot];
//    _nav3.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"机器人" image:[UIImage imageNamed:@"robot_unselect"] tag:1006];
//    _nav3.tabBarItem.selectedImage = [[UIImage imageNamed:@"robot_select"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    self.viewControllers = @[_nav1,_nav2];
    self.delegate = self;
    self.tabBar.tintColor = [UIColor blackColor];
}

#ifdef isIOS7
    web.edgesForExtendedLayout = UIRectEdgeNone;
    home.edgesForExtendedLayout = UIRectEdgeNone;
    robot.edgesForExtendedLayout = UIRectEdgeNone;
//    set.edgesForExtendedLayout = UIRectEdgeNone;
#endif


@end
