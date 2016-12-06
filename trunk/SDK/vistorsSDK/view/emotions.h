//
//  emotions.h
//  53kf_iOS
//
//  Created by tagaxi on 14-8-28.
//  Copyright (c) 2014年 Linda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FaceModel.h"
@protocol emotionsDelegate <NSObject>
@optional
-(void)selectEmotion:(NSString*)emotionStr isAutoSend:(BOOL)isAutoSend; //如果是默认表情到输入框，自定义表情直接发送 
-(void)deleteSelectedEmotion:(NSString*)emotionStr;
-(void)sendMessage;
@end
@interface emotions : UIView<UIScrollViewDelegate>

@property (nonatomic,strong)UIScrollView *scrollView ;
@property (nonatomic,strong)UIPageControl *pageC;
@property (nonatomic,strong)UISegmentedControl *segment;
@property (nonatomic,strong)UIView *defaultEmoji,*customizeEmoji;
@property (nonatomic,strong)NSArray *latelyEmotions,*allEmtions;
@property (nonatomic,weak)id<emotionsDelegate>delegate;
@property (nonatomic,strong) NSMutableArray *selectedEmotions,*emotionforLately;
@property (nonatomic,strong)  FaceModel *model;

@end
