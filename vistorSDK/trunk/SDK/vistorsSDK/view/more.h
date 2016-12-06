//
//  more.h
//  53kfiOS
//
//  Created by tagaxi on 15/3/24.
//  Copyright (c) 2015年 wenqing. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol moreDelegate <NSObject>
@optional
-(void)takePhotoes:(NSString *)type;
-(void)pictureFromCameral:(NSString*)type;
-(void)voiceSentance;
-(void)crmSentance;
@end
@interface more : UIView<UIActionSheetDelegate>
@property (nonatomic,weak)id<moreDelegate>delegate;
@property (nonatomic,strong)UIButton *pictures,*cameral,*voice,*crmButton;
@end
