//
//  chat_ViewController.h
//  53kf_iOS
//
//  Created by tagaxi on 14-8-20.
//  Copyright (c) 2014年 Linda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "emotions.h"
#import "TQRichTextView.h"
#import "more.h"
#import "vioceObject.h"
#import <AVFoundation/AVFoundation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import "Amr2Wav.h"
#import <mediaPlayer/MPMusicPlayerController.h>
#import <MediaPlayer/MediaPlayer.h>
#import "imageProcess.h"
#import "score.h"
#import "commodity.h"
#import "InputTextView.h"


@interface chat_ViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,TQRichTextViewDelegate,emotionsDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,moreDelegate,UISearchBarDelegate,UISearchDisplayDelegate,upLoadFileResultDelegate,scoreDelegate,InputTextDelegate,commodityDelegate>
@property (nonatomic,strong) UITableView *table ;
@property (nonatomic,strong) UIToolbar *tool;
@property (nonatomic,strong) InputTextView *textF;
@property (nonatomic,strong) NSMutableArray *messageArr;
@property (nonatomic,strong) UIRefreshControl *refresh;
@property (nonatomic,assign) BOOL isFromSelf;
@property (nonatomic,assign) long long foreTime;
@property (nonatomic,strong) NSMutableArray *RichTextArr,*RichTextSize;
@property (nonatomic,strong) NSString *guestid;
@property (nonatomic,strong) UIButton *emotions,*usualButton,*moreBut,*textButton,*voiceButton,*sendBtn;
@property (nonatomic,strong) NSMutableDictionary *IndicatorDic,*voiceDic,*myInfoDic,*guestInfo,*tempMessage,*commodityDic;
@property (nonatomic,strong) AVAudioPlayer *player;
@property (nonatomic,strong) vioceObject *voiceObj;
@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSArray *filterData;

@property(nonatomic,strong)UIImage *myHead;
@property(nonatomic,strong)UIView *showCRMView, *refreshV,*toolView;
@property (nonatomic, strong) UIImageView *showImageView;
@property (nonatomic, strong) score *scoreView;
@property(nonatomic,strong)NSString *titleStr;//title显示名字

@property(nonatomic)BOOL isRobot,isLeave;//是否是机器人或者离线消息
//@property (nonatomic,strong) NSTimer *timerForMessage;
//@property (nonatomic,strong) UIActivityIndicatorView *messageIndicator;
+(NSString*)getTimeUtil1970:(NSString*)time;


@end
