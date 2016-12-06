//
//  WebViewController.m
//  vistorsSDK
//
//  Created by tanghy on 16/4/22.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "WebViewController.h"
#import "HomeTableViewController.h"
#import <WebKit/WebKit.h>

@interface WebViewController ()<UIWebViewDelegate>

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initViews];
    // Do any additional setup after loading the view.
}


-(void)initViews{
    
    self.navigationItem.title = @"主页";
    
    UIWebView *web = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight+40)];
    web.delegate = self;
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.1shen7.com"]]];
    web.scalesPageToFit = YES;
    
    UIImageView *click2Talk = [[UIImageView alloc]initWithFrame:CGRectMake(screenWidth-100, 80, 80, 30)];
    click2Talk.image = [UIImage imageNamed:@"icon-4-on"];
    click2Talk.userInteractionEnabled = YES;
    [click2Talk addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(talks)]];
    
    [self.view addSubview:web];
    [self.view addSubview:click2Talk];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)talks{
    [self.navigationController pushViewController:[[HomeTableViewController alloc] init] animated:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"============should");
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"============网页加载成功");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"============网页加载失败 Error:%@",error.localizedDescription);
}

@end
