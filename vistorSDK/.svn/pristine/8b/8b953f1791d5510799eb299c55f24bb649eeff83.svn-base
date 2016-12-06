//
//  commodity.h
//  vistorsSDK
//
//  Created by tanghy on 16/8/17.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol commodityDelegate <NSObject>
@optional
-(void)sendCommodity:(NSDictionary*)commodityDic;
@end

@interface commodity : UIView

@property(nonatomic,strong)id<commodityDelegate> delegate;

@property(nonatomic,strong) NSDictionary *commodityDic;

@end
