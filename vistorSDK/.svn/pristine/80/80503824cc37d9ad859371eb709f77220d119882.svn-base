//
//  RobotViewController.m
//  vistorsSDK
//
//  Created by tanghy on 16/5/16.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "RobotViewController.h"
#import "chat_ViewController.h"

@interface RobotViewController ()

@property(strong,nonatomic) UILabel *timelable;
@end

@implementation RobotViewController

int gotime;
NSTimer *goTimer;


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"机器人";
    _timelable = [[UILabel alloc]initWithFrame:CGRectMake(0, screenHeight/2, screenWidth, 20)];
    _timelable.textAlignment = NSTextAlignmentCenter;
    _timelable.text = @"机器人加载中.... 3s后跳转到机器人接待！";
    [self.view addSubview:_timelable];
       // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    gotime = 0;
    goTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(goChat) userInfo:nil repeats:YES];
    [goTimer fire];
    

}

-(void)goChat{
    _timelable.text= [NSString stringWithFormat:@"机器人加载中.... %is后跳转到机器人接待！",3-gotime];
    if (gotime>=3) {
        chat_ViewController *chat = [chat_ViewController alloc];
        chat.isRobot = YES;
        [self.navigationController pushViewController:[chat init] animated:YES];
    }
   gotime++;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (goTimer) {
        [goTimer invalidate];
        goTimer = nil;
 
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
