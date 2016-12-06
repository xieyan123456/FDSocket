//
//  score.h
//  vistorsSDK
//
//  Created by tanghy on 16/4/19.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum{
    Defaulte,
    Fruit,
}SCORETYPE;

@protocol scoreDelegate <NSObject>
-(void)commitScoreNumber:(BOOL)type voteScore:(NSString *)voteScore score:(NSString*)score;
@end

@interface score : UIView

@property(nonatomic,strong)id<scoreDelegate> delegate ;
-(id)initWithFrame:(CGRect)frame style:(SCORETYPE)style;


@end
