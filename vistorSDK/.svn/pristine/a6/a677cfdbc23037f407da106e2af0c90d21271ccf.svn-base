//
//  news.h
//  vistorsSDK
//
//  Created by tanghy on 16/8/25.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol newsDelegate <NSObject>
@optional
-(void)goNewsPage:(NSDictionary*)newsInfo;//跳转到商品页面

@end


@interface news : UIView

@property(nonatomic,strong) id<newsDelegate> delegate;
@property(nonatomic,strong)NSDictionary *newsInfoDic;

@end
