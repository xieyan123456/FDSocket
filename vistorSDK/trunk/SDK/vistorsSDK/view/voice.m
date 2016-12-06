//
//  voice.m
//  53kfiOS
//
//  Created by tagaxi on 15/3/31.
//  Copyright (c) 2015年 wenqing. All rights reserved.
//

#import "voice.h"

@implementation voice
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code

        [self record];
        
        UIImage *nopress = [UIImage imageNamed:@"nopress"];
        CGFloat spaceX=(screenWidth-nopress.size.width) / 2.0;
        CGFloat spaceY=(frame.size.height - nopress.size.height) / 2.0;
        
        _voiceBut = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceBut setFrame:CGRectMake(spaceX, spaceY , nopress.size.width, nopress.size.height)];
        [_voiceBut setImage:nopress forState:UIControlStateNormal];
        [_voiceBut addTarget:self action:@selector(ReadyForVoice:) forControlEvents:UIControlEventTouchDown];
        [_voiceBut addTarget:self action:@selector(SendVoice:) forControlEvents:UIControlEventTouchUpInside];
        [_voiceBut addTarget:self action:@selector(DismissVoice:) forControlEvents:UIControlEventTouchDragExit];
//        [self addSubview:_voiceBut];
        
        _leftpoint = [[UIImageView alloc]init];//[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"point"]];
        _leftpoint.backgroundColor = [UIColor redColor];
        _leftpoint.layer.cornerRadius=1.5;
        [_leftpoint setFrame:CGRectMake(spaceX + 10, spaceY / 2, 3, 3)];
        
        
        _rightpoint = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"point"]];
        [_rightpoint setFrame:CGRectMake(frame.size.width - spaceX - 10, spaceY / 2, 3, 3)];
        
        
        _timelabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 40,frame.size.width , 15)];
//        _timelabel.center=CGPointMake(spaceX + (nopress.size.width / 2.0), spaceY / 2.0);
        _timelabel.textAlignment = NSTextAlignmentCenter;
        _timelabel.text = @"0";
        
        
        _noticelabel = [[UILabel alloc]initWithFrame:CGRectMake(0 , 70, frame.size.width, 20)];
//        _noticelabel.center=CGPointMake(spaceX + (frame.size.width / 2.0), frame.size.height - (spaceY / 2.0));
        _noticelabel.text = @"按住说话";
        _noticelabel.textAlignment = NSTextAlignmentCenter;
        _noticelabel.textColor = RedDif;
        [self addSubview:_noticelabel];
    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor whiteColor];
    return self;
}
-(void)record
{
    AVAudioSession *session = [AVAudioSession sharedInstance];
    NSError *sessionError = nil;
   [session setCategory:AVAudioSessionCategoryPlayAndRecord error:&sessionError];
    BOOL success = [session overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:&sessionError];
    if (!success) {
        NSLog(@"播放出错～%@",[sessionError description]);
    }
    [session setActive:YES error:&sessionError];
    
    sessionError = nil;
    if (sessionError) {
        NSLog(@"播放出错～%@",[sessionError description]);
        return;
    }

    //录音设置
    NSMutableDictionary *recorderSetting = [[NSMutableDictionary alloc]init];
    //设置录音格式 AVFormatIDKey==kAudioFormatLinearPCM
    [recorderSetting setValue:[NSNumber numberWithInt:kAudioFormatLinearPCM] forKey:AVFormatIDKey];
    //设置录音采样率（Hz）如：AVSampleRateKey==8000/44100/96000（影响音频的质量）
    [recorderSetting setValue:[NSNumber numberWithInt:8000] forKey:AVSampleRateKey];
    //录音通道数 1或2
    [recorderSetting setValue:[NSNumber numberWithInt:1] forKey:AVNumberOfChannelsKey];
    //线性采样位数 8、16、24、32
    [recorderSetting setValue:[NSNumber numberWithInt:16] forKey:AVLinearPCMBitDepthKey];
    //录音质量
    [recorderSetting setValue:[NSNumber numberWithInt:AVAudioQualityHigh] forKey:AVEncoderAudioQualityKey];
    
    NSString *URLstr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    urlvoice =[NSString stringWithFormat:@"%@/%.0f.wav",URLstr,[NSDate timeIntervalSinceReferenceDate]*1000.0];
    
    NSError *error = nil;
    recorder = [[AVAudioRecorder alloc]initWithURL:[NSURL URLWithString:urlvoice] settings:recorderSetting error:&error];
    if (!recorder) {
        NSLog(@"录制器不存在～%@",[error description]);
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"录制器不存在～" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
//    _itoast = [iToast makeText:@"请注意语音时间达到25秒，超过30秒自动发送"];
//    [_itoast setGravity:iToastGravityBottom offsetLeft:0 offsetTop:-160];
    
    //开启音量检测
    recorder.meteringEnabled = YES;
    recorder.delegate = self;
}


-(void)ReadyForVoice:(UIButton*)sender
{
    
    _noticelabel.text = @"松手发送";
    
    if ([recorder prepareToRecord]) {
        [recorder record];
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showTime:) userInfo:nil repeats:YES];
        if ([_timelabel.text isEqualToString:@"25"]) {
//            _itoast = [iToast makeText:@"请注意语音时间达到25秒，超过30秒自动发送"];
//            [_itoast setDuration:4];
//            [_itoast show];
        }
        if ([_timelabel.text isEqualToString:@"30"]) {
            [self SendVoice:_voiceBut];
            [timer invalidate];
        }

        [self addSubview:_leftpoint];
        [self addSubview:_rightpoint];
        [self addSubview:_timelabel];
       
        [_voiceBut setImage:[UIImage imageNamed:@"press"] forState:UIControlStateNormal];
    }else{
//        _itoast = [iToast makeText:@"准备中，请稍候"];
//        [_itoast setDuration:2];
//        [_itoast show];
    }
    
}
-(void)showTime:(id)sender
{
     _timelabel.text = [NSString stringWithFormat:@"%.0f",recorder.currentTime];
    
}

-(void)SendVoice:(UIButton*)sender
{
    
    
    
//    if ([_voiceBut.imageView.image isEqual:[UIImage imageNamed:@"press"]]) {
        double voiceTime = recorder.currentTime;
        if (voiceTime >1.0) {
            NSLog(@"准备发送！");
            [self transfer];
            [recorder stop];
        }else{
//            _itoast = [iToast makeText:@"时间太短！"];
//            [_itoast setDuration:2];
//            [_itoast show];
            [recorder stop];
            [recorder deleteRecording];
            
        }
        
        [_leftpoint removeFromSuperview];
        [_rightpoint removeFromSuperview];
        [_timelabel removeFromSuperview];
        
        
//        [_voiceBut setImage:[UIImage imageNamed:@"nopress"] forState:UIControlStateNormal];
    
        [timer invalidate];
        _timelabel.text = @"0";
        _noticelabel.text = @"按住说话";

//    }
}

-(void)DismissVoice:(UIButton*)sender
{
//    _itoast = [iToast makeText:@"已取消发送"];
//    [_itoast setDuration:2];
//    [_itoast show];
    [recorder deleteRecording];
    [recorder stop];
    [_leftpoint removeFromSuperview];
    [_rightpoint removeFromSuperview];
    [_timelabel removeFromSuperview];
    [timer invalidate];
    _timelabel.text = @"0";
     _noticelabel.text = @"按住说话";
//    [_voiceBut setImage:[UIImage imageNamed:@"press"] forState:UIControlStateNormal];
}
-(void)transfer
{
    NSString *URLstr = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *amr =[NSString stringWithFormat:@"%@/%.0f.amr",URLstr,[NSDate timeIntervalSinceReferenceDate]*1000.0];
    
    Other2Amr *other = [[Other2Amr alloc]initWithSourceAndDest:urlvoice dest:amr];
    
    if ([other startTransfer])
    {
        [_delegate sendVoiceWAV:urlvoice toAMR:amr duration:[_timelabel.text integerValue]];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
