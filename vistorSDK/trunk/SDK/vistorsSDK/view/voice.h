//
//  voice.h
//  53kfiOS
//
//  Created by tagaxi on 15/3/31.
//  Copyright (c) 2015年 wenqing. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

#import <AudioToolbox/AudioToolbox.h>
//#import "iToast.h"
#import "Other2Amr.h"
@protocol voiceDelegate <NSObject>
-(void)sendVoiceWAV:(NSString *)wavfile toAMR:(NSString*)amrfile duration:(NSInteger)duration;
@end
@interface voice : UIView<AVAudioRecorderDelegate>
{
    AVAudioRecorder *recorder;
    NSTimer *timer;
    NSString *urlvoice;
    
}
@property (nonatomic,strong)UIButton *voiceBut;
@property (nonatomic,strong)UILabel *timelabel,*noticelabel;
@property (nonatomic,strong)id<voiceDelegate>delegate;
@property (nonatomic,strong)UIImageView *leftpoint,*rightpoint;
//@property (nonatomic,strong)iToast *itoast;

-(void)ReadyForVoice:(UIButton*)sender;
-(void)SendVoice:(UIButton*)sender;
-(void)DismissVoice:(UIButton*)sender;
@end
