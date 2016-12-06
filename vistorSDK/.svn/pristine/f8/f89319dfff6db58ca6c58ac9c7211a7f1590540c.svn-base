//
//  chat_ViewController.m
//  53kf_iOS
//
//  Created by tagaxi on 14-8-20.
//  Copyright (c) 2014年 Linda. All rights reserved.
//

#import "chat_ViewController.h"
#import "MessageManager.h"
#import "HttpService.h"
#import "TZImagePickerController.h"
#import "Masonry.h"
#import "InputTextView.h"
#import "JLPhotoBrowser.h"
#import "SqliteDB.h"
#import "UIImageView+WebCache.h"
#import "commodity.h"
#import "news.h"
#import "MJRefresh.h"

#define PortraitWidth 40
#define PortraitHeight 40
#define buttonWidth 30
#define buttonHeight 30
#define arc4random_max 0x100000000
#define color [UIColor colorWithRed:213.0/255.0 green:213.0/255.0 blue:223.0/255.0 alpha:1.0f]
#define startNotice @"系统提示：访客建立会话成功"
#define endNotice @"系统提示：会话结束"
#define scorerQuest @"系统提示：评分成功"
#define vistorQueue @"系统提示：正在排队"
#define noCustomer  @"系统提示：暂无客服请留言"

@interface chat_ViewController ()<TZImagePickerControllerDelegate,newsDelegate>

{
    BOOL isOpenPic;
    BOOL isResponseILST;
    TQRichTextView *textView;
    NSString *crmTemp;
    NSNumber *animationDurationValue;
}

@property (nonatomic,assign) int messagePage;

@end

@implementation chat_ViewController

#pragma mark -懒加载

- (NSMutableDictionary *)tempMessage {
    if (!_tempMessage) {
        _tempMessage = [NSMutableDictionary dictionaryWithCapacity:20];
    }
    return _tempMessage;
}

- (NSMutableArray *)RichTextSize {
    if (!_RichTextSize) {
        _RichTextSize = [NSMutableArray arrayWithCapacity:20];
    }
    return _RichTextSize;
}

- (NSMutableArray *)RichTextArr {
    if (!_RichTextArr) {
        _RichTextArr = [NSMutableArray arrayWithCapacity:20];
    }
    return _RichTextArr;
}

- (NSMutableArray *)messageArr {
    if (!_messageArr) {
        _messageArr = [NSMutableArray arrayWithCapacity:20];
    }
    return _messageArr;
}

- (NSMutableDictionary *)IndicatorDic {
    if (!_IndicatorDic) {
        _IndicatorDic = [NSMutableDictionary dictionaryWithCapacity:20];
    }
    return _IndicatorDic;
}

#pragma mark -Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        [self setHidesBottomBarWhenPushed:YES];
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:101.0/255.0 green:160.0/255.0 blue:50.0/255.0 alpha:1]];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:101.0/255.0 green:160.0/255.0 blue:50.0/255.0 alpha:1],NSForegroundColorAttributeName, nil]];
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_bg"]  forBarMetrics:UIBarMetricsCompact];
    
    if(_titleStr){
        self.navigationItem.title = _titleStr;
    }else{
        self.navigationItem.title = @"人工客服";
    }
    [self setToolBar:YES ];
    self.view.backgroundColor = bgcolor;
    _table = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _table.separatorStyle = UITableViewCellSeparatorStyleNone;
    _table.delegate = self;
    _table.dataSource = self;
    _table.showsVerticalScrollIndicator = NO;
    _table.backgroundColor = bgcolor;
    _table.headerRefreshingText = @"下拉加载更多";
    _table.headerPullToRefreshText = @"松开立刻加载";
    
    __weak chat_ViewController *weakSelf = self;
    [_table addHeaderWithCallback:^{
        [weakSelf loadMessage];
    }];
    
    [self.view addSubview:_table];
    [_table mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.equalTo(_toolView.mas_top);
    }];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    
    self.messagePage = 0;
    [self loadMessage];
    
}

//加载聊天数据
-(void)loadMessage{
    if(!isOpenPic){
        self.messageArr = [SqliteDB selectAllMessage:self.messagePage];
        [self allMessage:self.messageArr isAtLastRow:self.messagePage==0];
        [_table headerEndRefreshing];
        self.messagePage++;
    }
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"QST" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(SQSTMessageNotify:) name:@"QST" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LNK" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeTitle:) name:@"LNK" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ULN" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changState:) name:@"ULN" object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"VOT" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scoreRequest:) name:@"VOT" object:nil];

    //如果是机器人进入第一步加载机器人详情
    if (_isRobot) {
        [self getRobotInfo];
    }

    isOpenPic = NO;
    isResponseILST = NO;
    if(_commodityDic != nil){
        commodity *commodityView =  [[commodity alloc]initWithFrame:CGRectMake(0, 0, screenWidth, 160)];
        commodityView.commodityDic = _commodityDic ;
        commodityView.delegate = self;
        [self.view addSubview:commodityView];
    }
    
    //评分界面
    //    [self addCRMAction:nil];
}

//对接收到的消息数组处理
- (void)allMessage:(NSArray*)msgArray isAtLastRow:(BOOL) isAtLastRow {
    
    __block NSMutableArray *textArr = [[NSMutableArray alloc]initWithCapacity:50];
    __block NSMutableArray *sizeArr = [[NSMutableArray alloc]initWithCapacity:50];
    
    BOOL isfromself = YES;
    
    UIImageView *image = [[UIImageView alloc]init];
    UIView *messageV = [[UIView alloc]init];
    NSString *string = [[NSString alloc]init];
    
    for(id msgDic in msgArray) {
        NSString *sid = [msgDic objectForKey:@"sid"];
    
        if ([sid isEqual: [Nationnal shareNationnal].srvid ] && ![[msgDic objectForKey:@"did"] isEqual:@"(null)"] && ![[msgDic objectForKey:@"did"] isKindOfClass:[NSNull class]]) {
            isfromself = YES;
        } else {
            isfromself = NO;
        }
        
        if ([msgArray indexOfObject:msgDic]==0){
            UILabel *timeLab = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-60, 10, 120, 20)];
            timeLab.textAlignment = NSTextAlignmentCenter;
            [timeLab setFont:[UIFont systemFontOfSize:12]];
            timeLab.text = [[self class]getTimeUtil1970:[msgDic objectForKey:@"time"]];
            [textArr addObject:timeLab];
            [sizeArr addObject:NSStringFromCGSize(timeLab.frame.size)];
            _foreTime = [[msgDic objectForKey:@"time"]longLongValue];
        }else{
            long long thisTime = [[msgDic objectForKey:@"time"] longLongValue];
            if (thisTime - _foreTime > 5*60000) {
                UILabel *timeLab0 = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-60, 10, 120, 20)];
                timeLab0.textAlignment = NSTextAlignmentCenter;
                [timeLab0 setFont:[UIFont systemFontOfSize:12]];
                timeLab0.text = [[self class]getTimeUtil1970:[msgDic objectForKey:@"time"]];
                [textArr addObject:timeLab0];
                [sizeArr addObject:NSStringFromCGSize(timeLab0.frame.size)];
            }
            _foreTime = [[msgDic objectForKey:@"time"]longLongValue];
        }

        NSString *typeStr = [msgDic objectForKey:@"type"];
        int type;
        if ([typeStr isEqualToString:@"text"]) {
            type = 1;
            if ([Util isFace:[msgDic objectForKey:@"msg"]]) {
                type = 2;
                [msgDic setValue:[SqliteDB getFaceByFaceName:[[msgDic objectForKey:@"msg"]substringWithRange:NSMakeRange(1, [[msgDic objectForKey:@"msg"] length]-2)]][@"face_path"] forKey:@"msg"];
            }
            
        } else if ([typeStr isEqualToString:@"image"]) {
            type = 2;
        } else if([typeStr isEqualToString:@"news"]){
            type = 3;
        }

        if (type==1) {
            
            string = [msgDic objectForKey:@"msg"];
            string = [Util replaceStringHtmlTag:string];
            string = [Util replaceStringByReg:@"<([^>]*)>" msg:string];
            
            if ([startNotice isEqualToString:string]||[endNotice isEqualToString:string] || [scorerQuest isEqualToString:string]|| [vistorQueue isEqualToString:string] ||[noCustomer isEqualToString:string]){
                
                UILabel *notice = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-117,0,234,30)];
                
                if ([endNotice isEqualToString:string]) {
                    [notice setFrame:CGRectMake(screenWidth/2-80,0,160,20)];
                }
                
                notice.textAlignment = NSTextAlignmentCenter;
                notice.text = string;
                notice.layer.masksToBounds = YES;
                notice.layer.cornerRadius =5.0;
                notice.textAlignment = NSTextAlignmentCenter;
                [notice setFont:[UIFont systemFontOfSize:14]];
                notice.textColor = [UIColor whiteColor];
                [notice setBackgroundColor:color];
                [textArr addObject:notice];
                [sizeArr addObject:NSStringFromCGSize(notice.frame.size)];
            }else{
                image = [self TQRichTextView:string and:isfromself];
                messageV = [self MessageView:image From:isfromself mark:@"record"];
                [textArr addObject:messageV];
                [sizeArr addObject:NSStringFromCGSize(messageV.frame.size)];
            }
            
        }else if (type==2){
            image =[self picture:[msgDic objectForKey:@"msg"] and:isfromself];
            messageV = [self MessageView:image From:isfromself mark:@"record"];
            [textArr addObject:messageV];
            [sizeArr addObject:NSStringFromCGSize(messageV.frame.size)];
        }else if(type == 3){
            image =[self newsMessage:[Util StringOrDic2NSDic:[msgDic objectForKey:@"msg"]] and:isfromself];
            messageV = [self MessageView:image From:isfromself mark:@"record"];
            [textArr addObject:messageV];
            [sizeArr addObject:NSStringFromCGSize(messageV.frame.size)];
        }

        //标示是否发送成功
        if ([[msgDic objectForKey:@"issend"] integerValue] == 0) {
            CGFloat x = image.center.x-image.frame.size.width/2-10-10;
            if (!isfromself) {
                x = image.center.x+image.frame.size.width/2+10+10;
            }
            
            UIImageView *failed = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
            [failed setImage:[UIImage imageNamed:@"fail"]];
            failed.center = CGPointMake(x,image.center.y);
            failed.userInteractionEnabled = YES;
            [messageV addSubview:failed];
            
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToResendMessage:)];
            [failed addGestureRecognizer:tap];

            NSString *marikid = [msgDic objectForKey:@"markid"];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
            [dic setObject:failed forKey:@"failed"];
            [dic setObject:messageV forKey:@"messageView"];
            [self.IndicatorDic setObject:dic forKey:marikid];
        }
        
    }

    self.RichTextArr = [[NSMutableArray alloc]initWithArray:textArr];
    self.RichTextSize = [[NSMutableArray alloc]initWithArray:sizeArr];
    [_table reloadData];
    
    if (isAtLastRow && [self.RichTextArr count]>0) {
        NSIndexPath *lastrow = [NSIndexPath indexPathForRow:[self.RichTextArr count]-1 inSection:0];
        [_table scrollToRowAtIndexPath:lastrow atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
    
}

- (void)tapToResendMessage:(UITapGestureRecognizer *)gesture {
    
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"重发消息" otherButtonTitles:nil, nil];
    for (NSMutableDictionary *dic in [self.IndicatorDic allValues]) {
        if ([[dic allValues] indexOfObject:gesture.view]!= NSNotFound) {
            [dic setObject:sheet forKey:@"sheet"];
        }
    }
    [sheet showInView:[UIApplication sharedApplication].keyWindow];
}

//获取格式化时间（秒数字符串转化为时分秒形式）
+(NSString*)getTimeUtil1970:(NSString*)time
{
    double times = [time longLongValue]/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:times];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"MM-dd HH:mm:ss"];
    NSString *currentDate =[formatter stringFromDate:date] ;
    return currentDate;
}
#pragma mark send&recieve message

//获取接收消息通知
- (void)SQSTMessageNotify:(NSNotification*)notfy {
    NSDictionary *mes = [Util StringOrDic2NSDic:notfy.object];
    BOOL isme = [[[mes objectForKey:@"from"] objectForKey:@"id"] isEqualToString:[Nationnal shareNationnal].srvid]?YES:NO;
    
    if ([[mes objectForKey:@"messageType"] isEqualToString:@"leave"]) {
        isme = [[[mes objectForKey:@"from"] objectForKey:@"type"] isEqualToString:@"guest"]?YES:NO;
    }
    int code = [[mes objectForKey:@"code"] intValue];
    
    if ([mes objectForKey:@"msg"]==nil ) {
        // 收到发送消息成功回执包
        
        NSString *markid = [mes objectForKey:@"packetId"];
        NSLog(@"QST应答：%@",markid);
        [SqliteDB updateOneMessageSendStateWithMarkID:markid];
        
        UIActivityIndicatorView *indicator =(UIActivityIndicatorView *)[[self.IndicatorDic objectForKey:markid] objectForKey:@"indicator"];
        [indicator removeFromSuperview];
        UIImageView *failed = (UIImageView*)[[self.IndicatorDic objectForKey:markid] objectForKey:@"failed"];
        UIView *message = (UIView*)[[self.IndicatorDic objectForKey:markid] objectForKey:@"message"];
        NSTimer *timer = (NSTimer*)[[self.IndicatorDic objectForKey:markid]objectForKey:@"timer" ];
        [timer invalidate];
        if ([[message subviews]indexOfObject:failed]!=NSNotFound) {
            [failed removeFromSuperview];
        }
        [self.IndicatorDic removeObjectForKey:markid];
        
    } else if (code == 0 && [mes[@"data_type"] intValue] == 1) {
        [self messageView:mes and:isme mark:@"received"];
        [self.messageArr arrayByAddingObject:mes];
        if ([self.RichTextArr count]==0) return;
        NSIndexPath *lastrow = [NSIndexPath indexPathForRow:[self.RichTextArr count]-1 inSection:0];
        [_table scrollToRowAtIndexPath:lastrow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
    
    
}


-(void)changeTitle:(NSNotification*)notfy{
    NSDictionary *mes = [Util StringOrDic2NSDic:notfy.object];
    if([[mes objectForKey:@"code"] integerValue]==2014){
        [self sendBufMessageWithType:nil msg:@"系统提示：正在排队" ];
    }else if([[mes objectForKey:@"code"] integerValue]==2009){
        [self sendBufMessageWithType:nil msg:@"系统提示：暂无客服请留言" ];
    }else {
        _isLeave = NO;
        self.navigationItem.title =  [[mes objectForKey:@"workerInfo"]objectForKey:@"nickName"];
    }
    
    
}

-(void)changState:(NSNotification*)notfy{
    _isLeave = YES;
    [self sendBufMessageWithType:nil msg:@"系统提示：会话结束" ];
    
}

-(void)messageView:(NSDictionary*)msgDic and:(BOOL)isfromself mark:(NSString*)markid {
    
    long long thisTime = [msgDic objectForKey:@"sort_time"] == nil ? [[msgDic objectForKey:@"time"] longLongValue]*1000 : [[msgDic objectForKey:@"sort_time"] longLongValue];
    
    if (thisTime - _foreTime > 5*60000) {
        UILabel *timeLab0 = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-100, 10, 200, 20)];
        timeLab0.layer.masksToBounds = YES;
        timeLab0.layer.cornerRadius =5.0;
        timeLab0.textAlignment = NSTextAlignmentCenter;
        [timeLab0 setFont:[UIFont systemFontOfSize:12]];
        timeLab0.text = [[self class]getTimeUtil1970:[NSString stringWithFormat:@"%lli",thisTime]];
        [self.RichTextArr addObject:timeLab0];
        [self.RichTextSize addObject:NSStringFromCGSize(timeLab0.frame.size)];
        _foreTime = thisTime;
    }
    
    NSString *typeStr = [msgDic objectForKey:@"type"];
    int type=1;
    if ([typeStr isEqualToString:@"text"]) {
        type = 1;
        //用正则匹配是否有自定义表情
        if ([Util isFace:[msgDic objectForKey:@"msg"]]) {
            type = 2;
            [msgDic setValue:@"image" forKey:@"type"];
            [msgDic setValue:[SqliteDB getFaceByFaceName:[[msgDic objectForKey:@"msg"]substringWithRange:NSMakeRange(1, [[msgDic objectForKey:@"msg"] length]-2)]][@"face_path"] forKey:@"msg"];
        }
    } else if ([typeStr isEqualToString:@"image"]) {
        type = 2;
    } else if([typeStr isEqualToString:@"news"]){
        type = 3;
    }
    
    UIImageView *MsgImg;
    
    if (type==1) {
        
        NSString *string = [msgDic objectForKey:@"msg"];
        
        if ([startNotice isEqualToString:string]||[endNotice isEqualToString:string] || [scorerQuest isEqualToString:string]|| [vistorQueue isEqualToString:string] || [noCustomer isEqualToString:string]){
            
            UILabel *noticeLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth/2-117, 0,234 , 20)];
            
            if (![startNotice isEqualToString:string]) {
                [noticeLabel setFrame:CGRectMake(screenWidth/2-80, 0,160 , 20)];
            }
            noticeLabel.textAlignment = NSTextAlignmentCenter;
            noticeLabel.text = string;
            noticeLabel.font = [UIFont systemFontOfSize:14];
            noticeLabel.layer.cornerRadius = 5.0;
            noticeLabel.layer.masksToBounds = YES;
            noticeLabel.textColor = [UIColor whiteColor];
            [noticeLabel setBackgroundColor:color];
            [self.RichTextArr  addObject:noticeLabel];
            [self.RichTextSize addObject:NSStringFromCGSize(noticeLabel.frame.size)];
            [_table reloadData];
            return;
            
        }else{
            string = [Util replaceStringHtmlTag:string];
            string = [Util replaceStringByReg:@"<([^>]*)>" msg:string];
            if ([[msgDic objectForKey:@"messageType"] isEqualToString:@"leave"]) {
                string = [NSString stringWithFormat:@"%@(离线)", string];
            }
            MsgImg = [self TQRichTextView:string and:isfromself];
        }
    }else if (type==2){
        NSString *imgUrl = [[Util StringOrDic2NSDic:[msgDic objectForKey:@"image"]] objectForKey:@"originPath"] == nil ? [msgDic objectForKey:@"msg"] : [[Util StringOrDic2NSDic:[msgDic objectForKey:@"image"] ] objectForKey:@"originPath"];
        MsgImg = [self picture:imgUrl and:isfromself];
    }else if(type == 3){
        MsgImg = [self newsMessage:msgDic and:isfromself];
    }
    
    if (markid != nil) {
        [self.tempMessage setObject:msgDic forKey:markid];
    }
    
    UIView *bubbleView = [self MessageView:MsgImg From:isfromself mark:markid];
    [self.RichTextSize addObject:NSStringFromCGSize(bubbleView.frame.size)];
    [self.RichTextArr addObject:bubbleView];
    [self.messageArr arrayByAddingObject:msgDic];
    [_table reloadData];
    [self.table scrollToRowAtIndexPath:[self lastRowIndexPath] atScrollPosition:UITableViewScrollPositionBottom animated:NO];

}

- (void)setToolBar:(BOOL)isShowTextfile {
    
    _toolView = [[UIView alloc]init];
    [self.view addSubview:_toolView];
    [_toolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    _toolView.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1.0f];
    
    _moreBut = [[UIButton alloc]init];
    [_toolView addSubview:_moreBut];
    [_moreBut mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
        make.left.mas_equalTo(12);
    }];
    [_moreBut setImage:[UIImage imageNamed:@"more_btn"] forState:UIControlStateNormal];
    [_moreBut setImage:[UIImage imageNamed:@"more_open_btn"] forState:UIControlStateSelected];
    [_moreBut addTarget:self action:@selector(moreButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _emotions = [[UIButton alloc]init];
    [_toolView addSubview:_emotions];
    [_emotions mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_moreBut.mas_right).offset(6);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(30);
    }];
    [_emotions setImage:[UIImage imageNamed:@"emoj_close_btn"] forState:UIControlStateNormal];
    [_emotions setImage:[UIImage imageNamed:@"emoj_open_btn"] forState:UIControlStateSelected];
    
    [_emotions addTarget:self action:@selector(emotionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _sendBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_toolView addSubview:_sendBtn];
    [_sendBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(-12);
        make.top.mas_equalTo(5);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(40);
    }];
    [_sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [_sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [_sendBtn addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _textF = [[InputTextView alloc]init];
    [_toolView addSubview:_textF];
    [_textF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_emotions.mas_right).offset(6);
        make.right.equalTo(_sendBtn.mas_left).offset(-6);
        make.top.mas_equalTo(5);
        make.bottom.mas_equalTo(-5);
    }];
    _textF.changeDelegate = self;
    _textF.returnKeyType = UIReturnKeySend;
    
}

- (void)sendButtonClicked:(UIButton *)sender {
    
    [_toolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
    }];
    [self sendBufMessageWithType:nil msg:_textF.text ];
    
}

- (void)emotionButtonClicked:(UIButton *)sender {
    
    if (_isRobot) {
        return;
    }
    
    [_textF resignFirstResponder];
    
    _emotions.selected = !_emotions.selected;
    _moreBut.selected = NO;
    
    if ([[[self.view subviews]lastObject]isKindOfClass:[more class]]) {
        [[[self.view subviews]lastObject]removeFromSuperview];
    }
    
    if (![[[self.view subviews]lastObject]isKindOfClass:[emotions class]]) {
        
        emotions *emtion = [[emotions alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, 216)];
        emtion.delegate = self;
        [self autoMoveKeyboard:216];
        [self.view addSubview:emtion];
        
        [UIView beginAnimations:@"Move Up" context:nil];
        [UIView setAnimationDuration:0.25];
        emtion.frame = CGRectMake(0, screenHeight-216-64, screenWidth, 216);
        [UIView commitAnimations];
        
    }else{
        [[[self.view subviews] lastObject] removeFromSuperview];
        [self autoMoveKeyboard:0];
    }
    
}

- (void)moreButtonClicked:(UIButton *)sender {
    
    if (_isRobot) {
        return;
    }
    
    [_textF resignFirstResponder];
    
    _moreBut.selected = !_moreBut.selected;
    _emotions.selected = NO;
    
    if ([[[self.view subviews]lastObject]isKindOfClass:[emotions class]]) {
        [[[self.view subviews]lastObject]removeFromSuperview];
    }
    
    if (![[[self.view subviews]lastObject]isKindOfClass:[more class]]) {
        
        more *moreview = [[more alloc]initWithFrame:CGRectMake(0, screenHeight, screenWidth, 216)];
        moreview.delegate = self;
        [self autoMoveKeyboard:216];
        [self.view addSubview:moreview];
        
        [UIView beginAnimations:@"Move Up" context:nil];
        [UIView setAnimationDuration:0.25];
        //这里写子视图要移动什么地方的代码
        moreview.frame = CGRectMake(0, screenHeight-64-216, screenWidth, 216);
        [UIView commitAnimations];
        
    }else{
        [[[self.view subviews] lastObject] removeFromSuperview];
        [self autoMoveKeyboard:0];
    }
    
}

#pragma mark TQRichTextView

//返回包含富文本的对话气泡
- (UIImageView *)TQRichTextView:(NSString*)string and:(BOOL)isfromself {
    CGRect rect = [TQRichTextView boundingRectWithSize:CGSizeMake(screenWidth-110, screenHeight*100) font:[UIFont systemFontOfSize:14] string:string lineSpace:1.1f];
    
    TQRichTextView *textV = [[TQRichTextView alloc]initWithFrame:CGRectMake(isfromself?10:15,8, rect.size.width, rect.size.height)];
    textV.delegage = self;
    textV.text = string;
    textV.lineSpace = 1.1f;
    textV.font = [UIFont systemFontOfSize:14];
    textV.backgroundColor = [UIColor clearColor];
    textV.userInteractionEnabled = YES;
    
    UIImageView *imagev = [self bubbleview:rect.size andfrom:isfromself];
    
    [imagev addSubview:textV];
    
    return imagev;
}

//如果点击了文本中的URL链接
- (void)richTextView:(TQRichTextView *)view touchEndRun:(TQRichTextRun *)run
{
    if ([run isKindOfClass:[TQRichTextRunURL class]])
    {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:run.text]];
    }
    NSLog(@"%@",run.text);
}


#pragma mark-- copy&Paste
//defalt is No UIMenuController 所在View必须实现该方法，并且返回YES
-(BOOL)canBecomeFirstResponder
{
    return  YES;
}

//针对copy的实现
-(void)copy:(id)sender
{
    UIPasteboard *poard = [UIPasteboard generalPasteboard];
    poard.string = textView.text;
}

//按钮acm执行
-(void)addCRMAction:(id)sender
{
    
    _scoreView =  [[score alloc]initWithFrame:CGRectMake(0, screenHeight-234, screenWidth, 234) style:Fruit];
    _scoreView.delegate = self;
    [self.view addSubview:_scoreView];
    
}

-(void)crmSentance{
    if([[[self.view subviews]lastObject]isKindOfClass:[more class]]){
        [[[self.view subviews]lastObject]removeFromSuperview];
    }
    [_textF resignFirstResponder];
    [self autoMoveKeyboard:0];
    
    
    
    if (_scoreView==nil) {
        _scoreView =   [[score alloc]initWithFrame:CGRectMake(0, screenHeight-234, screenWidth, 234) style:Fruit];
        _scoreView.delegate = self;
        [self.view addSubview:_scoreView];
        return;
    }else{
        [_scoreView removeFromSuperview];
        _scoreView = nil;
    }
    
    //添加提示评分成功提示语
    NSMutableDictionary *scoreDic = [[NSMutableDictionary alloc]init];
    [scoreDic setObject:@"系统提示：评分成功" forKey:@"msg"];
    [scoreDic setObject:@"text" forKey:@"type"];
    [scoreDic setObject:[NSNumber numberWithLongLong:[Util getTimeUtil1970]] forKey:@"sort_time"];
    
    
    [self messageView:scoreDic and:YES mark:nil];
    
}

-(void)commitScoreNumber:(BOOL)type voteScore:(NSString *)voteScore score:(NSString*)score{
    
    Message *scoreMsg  = [MessageManager getBufVOTbody:score voteScore:voteScore  response:type];
    [[IMSocket sharedObject] sendMessage:scoreMsg];
    //    [[ConnBufferService connSocket]sendMessage:scoreMsg];
    [_scoreView removeFromSuperview];
    _scoreView = nil;
}

#pragma mark-- dialog view for words and picture
//生成图片消息气泡
- (UIImageView*)picture:(NSString*)msg and:(BOOL)isfromself {
    
    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(isfromself?5:15, 5, 100, 100)];
    
    if([msg rangeOfString:@"://"].length>0){
        [image sd_setImageWithURL:[NSURL URLWithString:msg] placeholderImage:[UIImage imageNamed:@"noData"]];
    }else{
        image.image = [imageProcess getUIImageByName:msg];
    }

    image.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToShowBigImage:)];
    [image addGestureRecognizer:tap];

    UIImageView *imagev = [self bubbleview:image.frame.size andfrom:isfromself];
    [imagev addSubview:image];
    return imagev;
}

- (void)tapToShowBigImage:(UITapGestureRecognizer *)tap {
    
    UIImageView *tappedImageView = nil;
    if ([tap.view isKindOfClass:[UIImageView class]]) {
        tappedImageView = (UIImageView *)tap.view;
    }else {
        return;
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:tappedImageView.image];
    JLPhotoBrowser *browser = [[JLPhotoBrowser alloc] init];
    [self.view addSubview:imageView];
    browser.photos = [NSArray arrayWithObjects:imageView, nil];
    [browser show];
    
}

//生成图片消息气泡
- (UIImageView*)newsMessage:(NSDictionary*)msg and:(BOOL)isfromself {
    news *newView = [[news alloc] init];
    newView.delegate = self;
    newView.newsInfoDic = msg;
    UIImageView *imagev = [self bubbleview:newView.frame.size andfrom:isfromself];
    newView.frame = CGRectMake(newView.frame.origin.x, newView.frame.origin.y+5, newView.frame.size.width, newView.frame.size.height);
    [imagev addSubview:newView];
    return imagev;
}

//生成对话气泡
-(UIImageView*)bubbleview:(CGSize)size andfrom:(BOOL)isfromself
{
    UIImage *bubble = [UIImage imageNamed:isfromself?(@"chat_right_bg"):(@"chat_left_bg")];
    UIImageView *imageV = [[UIImageView alloc]initWithImage:[bubble stretchableImageWithLeftCapWidth:floorf(bubble.size.width*0.5) topCapHeight:floorf(bubble.size.height*0.6)]];
    imageV.userInteractionEnabled = YES;
    float offsizeY =  size.height<30?10:5;
    size.width = size.width>26?size.width:26;
    if(_myHead){
        [imageV setFrame:CGRectMake(isfromself?screenWidth- size.width-PortraitWidth-40:PortraitWidth+11, offsizeY,size.width+30,size.height+20)];
    }else{
        [imageV setFrame:CGRectMake(isfromself?screenWidth- size.width-40:PortraitWidth+11, offsizeY,size.width+30,size.height+20)];
    }
    return imageV;
}

//生成完整消息视图（包含头像和气泡）
-(UIView*)MessageView:(UIImageView*)bubble From:(BOOL)isfromself mark:(NSString*)markid
{
    UIImageView *portrait = [[UIImageView alloc]initWithFrame:CGRectMake(isfromself?screenWidth-PortraitWidth-7:7, 5, PortraitWidth, PortraitHeight)];
    portrait.layer.masksToBounds = YES;
    portrait.layer.cornerRadius = 20.0;
    [portrait setImage:isfromself?[UIImage imageNamed:@"font_set_left"]:[UIImage imageNamed:@"Shape"]];
    
    UIView *message = [[UIView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, bubble.bounds.size.height+10)];
    if (!isfromself) {
        [message addSubview:portrait];
    }else{
        if (_myHead) {
            portrait.image = _myHead;
            [message addSubview:portrait];
        }
    }
    [message addSubview:bubble];

    if (![markid isEqualToString:@"record"]&&![markid isEqualToString:@"received"] && markid !=nil) {
        
        NSMutableDictionary *sendMessage = [[NSMutableDictionary alloc]init];
        UIActivityIndicatorView *messageIndicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        CGFloat x = bubble.center.x-bubble.frame.size.width/2-10-messageIndicator.frame.size.width/2;
        if (!isfromself) {
            x = bubble.center.x+bubble.frame.size.width/2+10+messageIndicator.frame.size.width/2;
        }
        messageIndicator.center = CGPointMake(x,bubble.center.y);
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:50.0 target:self selector:@selector(SucessedOrFailed:) userInfo:message repeats:NO];
        [sendMessage setObject:message forKey:@"messageView"];
        [sendMessage setObject:messageIndicator forKey:@"indicator"];
        [sendMessage setObject:timer forKey:@"timer"];
        [self.IndicatorDic setObject:sendMessage forKey:markid];
        
    }
    return message;
}



//点击播放语音消息
-(void)palyVoice:(UITapGestureRecognizer*)tap
{
    UIImageView *imageV = (UIImageView*)tap.view;
    NSString *path = nil;
    for (NSString *p in [_voiceDic allKeys]) {
        if ([[[_voiceDic objectForKey:p]allValues]indexOfObject:imageV]!=NSNotFound) {
            path = p;
            break;
        }
    }
    
    
    AVAudioSession *audioSession = [AVAudioSession sharedInstance];
    //    if([[NSUserDefaults standardUserDefaults]boolForKey:speaker_play_voice]){
    //        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    //    }else{
    [audioSession setCategory:AVAudioSessionCategoryPlayback error:nil];
    //    }
    
    [audioSession setActive:YES error:nil];
    if (_player.isPlaying) {
        [_player stop];
    }
    NSError *error = nil;
    _player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:path] error:&error];
    _player.volume = 1.0;
    _player.numberOfLoops = 0;
    
    if (error) {
        NSLog(@"播发器出错：%@",[error description]);
    }
    
    [_player prepareToPlay];
    if (!_player.isPlaying) {
        [_player play];
    }
    
}

//检测消息是否发送失败
-(void)SucessedOrFailed:(NSTimer*)timer
{
    if (![timer.userInfo isKindOfClass:[UIView class]]) {
        return;
    }
    
    UIView *message = (UIView*)timer.userInfo ;
    UIActivityIndicatorView *indicator = nil;
    for (UIView *subview in [message subviews]) {
        if ([subview isKindOfClass:[UIActivityIndicatorView class]]) {
            indicator = (UIActivityIndicatorView*)subview;
        }
    }
    UIImageView *failed = [[UIImageView alloc]initWithFrame:indicator.frame];
    [failed setImage:[UIImage imageNamed:@"fail"]];
    failed.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToResendMessage:)];
    [failed addGestureRecognizer:tap];

    //    if (indicator.isAnimating) {
    //        [indicator stopAnimating];
    [indicator removeFromSuperview];
    //    }
    for (NSMutableDictionary *dic in [self.IndicatorDic allValues]) {
        if ([[dic allValues] indexOfObject:indicator]!= NSNotFound) {
            [dic setObject:failed forKey:@"failed"];
        }
    }
    [message addSubview:failed];
    
}

#pragma mark - ActionSheet
//重发消息回调
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    NSString *markid = nil;
    //找到_indicatorDic中actionSheet对应的mark
    for (NSMutableDictionary *dic in [self.IndicatorDic allValues]) {
        if ([[dic allValues] indexOfObject:actionSheet]!= NSNotFound) {
            
            for (NSString *mark in [self.IndicatorDic allKeys]) {
                if ([dic isEqual:[self.IndicatorDic objectForKey:mark]]) {
                    markid = mark;
                }
            }
        }
    }
    
    if (buttonIndex == 0) {
        
        NSDictionary *dic = [SqliteDB getMessageByMarkid:markid];
        Message *message = [[Message alloc] init];
        NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
        if([dic[@"type"] isEqualToString:@"image"]){
            //如果是图片没有发送成功先上传再发送
            UIImage *image = [imageProcess getUIImageByName:dic[@"msg"]];
            imageProcess *upload = [[imageProcess alloc]init];
            [upload uploadImageWithimage:image completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                
                if (error) {
                    NSLog(@"============Error:%@",error.localizedDescription);
                }else {
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        if ([[responseObject objectForKey:@"code"] intValue] == 0) {
                            NSString *responseStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                            Message *message = [MessageManager getBufQSTBody:responseStr type:@"image" packNumber:markid isLeave:_isLeave];
                            [[IMSocket sharedObject] sendMessage:message];
                        }
                    }
                }
                
            }];
            
        }else{
            
            [bodyDic setValue:@"QST" forKey:@"cmd"];
            [bodyDic setValue:[Nationnal shareNationnal].srvid forKey:@"sid"];
            [bodyDic setValue:[Nationnal shareNationnal].kfid forKey:@"did"];
            [bodyDic setValue:[Nationnal shareNationnal].chatid forKey:@"chatId"];
            [bodyDic setValue:@"text" forKey:@"type"];
            [bodyDic setValue:[Nationnal shareNationnal].token forKey:@"token"];
            [bodyDic setValue:[[self.tempMessage objectForKey:markid]objectForKey:@"msg"] forKey:@"msg"];
            [bodyDic setValue:markid forKey:@"markid"];
            [bodyDic setValue:@"" forKey:@"image"];
            
            NSString *body = [Util dictionary2String:bodyDic];
            NSString *packNum = markid;
            message = [[[[[[message builder] setProtocol:1] setBodyLength:(int)body.length] setPackageId:packNum] setBody:body] build];
            // 想buffer发送消息
            [[IMSocket sharedObject] sendMessage:message];
            //            [[ConnBufferService connSocket] sendMessage:message];
        }
        
        //消息发送状态指示视图
        NSMutableDictionary *mdic = [self.IndicatorDic objectForKey:markid];
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:50.0 target:self selector:@selector(SucessedOrFailed:) userInfo:message repeats:NO];
        [mdic setObject:timer forKey:@"timer"];
        
        if (![mdic objectForKey:@"indicator"]) {
            UIImageView *failed = (UIImageView*)[mdic objectForKey:@"failed"];
            UIActivityIndicatorView *indictor = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [indictor setFrame:failed.frame];
            [mdic setObject:indictor forKey:@"indicator"];
        }
        
        UIActivityIndicatorView *indictor = (UIActivityIndicatorView*)[mdic objectForKey:@"indicator"];
        UIView *view = (UIView*)[mdic objectForKey:@"messageView"];
        UIImageView *failed = (UIImageView*)[mdic objectForKey:@"failed"];
        [failed removeFromSuperview];
        [view addSubview:indictor];
        [indictor startAnimating];
        
    }
    
    
    
    
}

#pragma mark UIRefreshControl
//请求接下来的15条消息
-(void)requestNewData
{
    
}

//刷新成功指示
- (void)showRefresh {
    UILabel *showLB = [[UILabel alloc] initWithFrame:CGRectMake(0, -30, screenWidth, 30)];
    showLB.textAlignment = NSTextAlignmentCenter;
    showLB.backgroundColor = [UIColor colorWithRed:18 / 255.0 green:17 / 255.0 blue:17 / 255.0 alpha:.85];
    showLB.text = @"刷新成功";
    showLB.textColor = [UIColor whiteColor];
    showLB.font = [UIFont systemFontOfSize:12];
    
    [self.table setFrame:CGRectMake(0, 30, screenWidth, screenHeight-64-49-30)];
    self.refreshV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 30)];
    [self.refreshV.viewForBaselineLayout addSubview:showLB];
    [self.view addSubview:self.refreshV];
    
    [UILabel animateWithDuration:.5 animations:^{
        [showLB setFrame:CGRectMake(0, 0, screenWidth, 30)];
    }];
    
    [UITableView animateWithDuration:1 animations:^{
        [self.table setFrame:CGRectMake(0, 0, screenWidth, screenHeight-64-49-30)];
    } completion:^(BOOL finished) {
        [self.table setFrame:CGRectMake(0, 0, screenWidth, screenHeight-64-49)];
        [showLB setFrame:CGRectMake(0, -30, screenWidth, 30)];
        [self.refreshV removeFromSuperview];
    }];
    
}

#pragma mark responding to keyboard events
//键盘将要弹出时 先移除之前的emotions视图  （因为每次点击表情按钮都会新建一个emotions视图，所以再新建之前先移除之前的视图 ，防止内存占用异常）
-(void)keyboardWillChangeFrame:(NSNotification*)notification
{
    NSLog(@"======notification %@",notification);
    
    //移除原视图
    [self removeAllChatTools];
    
    NSDictionary *userInfo = [notification userInfo];
    
    NSValue *avalue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    
    CGRect keyboardRect = [avalue CGRectValue];
    
    animationDurationValue = [userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey];
    //    NSTimeInterval animationDuration ;
    //    [animationDurationValue getValue:&animationDuration];
    
    /**
     *  计算toolBar偏移量
     */
    //    CGFloat originToolBarY=screenHeight-104;//toolBar起始位置Y坐标
    //    CGFloat afterMoveToolBarY=keyboardRect.origin.y-104;//键盘相对于tableView坐标系的Y坐标
    CGFloat offsetY=screenHeight-keyboardRect.origin.y;
    NSLog(@"toolBar offsetY=%f",offsetY);
    /**
     *  changeFrame方法只负责除了隐藏键盘外所有的键盘变化情况 （主要考虑到键盘正在显示时，点击表情等按钮需要先隐藏键盘，防止toolBar跟着下去然后上来到表情视图位置，动画效果不佳，直接移动到表情视图最终位置比较好，该移动由autoMoveKeyboard方法独立完成，同理，隐藏键盘动画也由autoMoveKeyboard方法完成）
     */
    if(offsetY == 0){
        NSLog(@"this is a keyboard hide notification ,the method \"keyboardWillChangeFrame\" will return !");
        return;
    }
    
    [self autoMoveKeyboard:offsetY];
    
}

//移动_table 和_tool
-(void)autoMoveKeyboard:(float)h{
    if (h==0) {
        _emotions.selected = NO;
        _moreBut.selected = NO;
    }
    [self removeAllChatTools];
    [UIView animateWithDuration:0.25 animations:^{
        [_toolView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(-h);
        }];
        
    }];
    if( h != 0){
        dispatch_after(0.3, dispatch_get_main_queue(), ^{
            if ([self.RichTextArr count]>0) {
                NSIndexPath *lastrow = [NSIndexPath indexPathForRow:[self.RichTextArr count]-1 inSection:0];
                [_table scrollToRowAtIndexPath:lastrow atScrollPosition:UITableViewScrollPositionBottom animated:NO];
            }
        });
    }
}

-(void)removeAllChatTools{
    if ([[[self.view subviews]lastObject]isKindOfClass:[emotions class]]) {
        
        [[[self.view subviews]lastObject]removeFromSuperview];
        
    }else if ([[[self.view subviews]lastObject]isKindOfClass:[more class]]){
        [[[self.view subviews]lastObject]removeFromSuperview];
    }
    //    else if ([[[self.view subviews]lastObject]isKindOfClass:[voice class]])
    //    {
    //        [[[self.view subviews]lastObject]removeFromSuperview];
    //    }
}

-(NSIndexPath *)lastRowIndexPath{
    return [NSIndexPath indexPathForRow:[self.RichTextArr count]-1 inSection:0];
}

#pragma mark --按钮触发的方法



//从系统相册或摄像头选取图片
-(void)pictureFromCameral:(NSString*)type
{
    
    isOpenPic =YES;
    if ([[[self.view subviews]lastObject]isKindOfClass:[emotions class]]) {
    }
    
    [self openCanmeOrPhoto:type];
    
}
//调用照相机
-(void)takePhotoes:(NSString *)type
{
    [self openCanmeOrPhoto:type];
}

//调用系统相册
-(void)openCanmeOrPhoto:(NSString*)type
{
    
    if ([type isEqualToString:@"library"]) {
        [self pushImagePickerController];
    }else{
        UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
        if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera; //相机
            pickerImage.mediaTypes = [UIImagePickerController availableMediaTypesForSourceType:pickerImage.sourceType];
            pickerImage.delegate = self;
            [self presentViewController:pickerImage animated:YES completion:nil];
        }
        
    }
}


- (void)pushImagePickerController {
    
    [self autoMoveKeyboard:0];
    
    isOpenPic =YES;
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:9 delegate:self];
    
    
    // 1.如果你需要将拍照按钮放在外面，不要传这个参数
    imagePickerVc.allowTakePicture = YES; // 在内部显示拍照按钮
    
    // 3. 设置是否可以选择视频/图片/原图
    imagePickerVc.allowPickingVideo = NO;
    imagePickerVc.allowPickingImage = YES;
    imagePickerVc.allowPickingOriginalPhoto = NO;
    
    
    // You can get the photos by block, the same as by delegate.
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        
    }];
    
    [self presentViewController:imagePickerVc animated:YES completion:nil];
}

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    [_textF resignFirstResponder];
    [self autoMoveKeyboard:0];
    
    for (UIImage *img in photos) {
        dispatch_async(dispatch_get_main_queue(), ^{
            imageProcess *upload = [[imageProcess alloc]init];
            [upload uploadImageWithimage:img completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
                
                if (error) {
                    NSLog(@"============Error:%@",error.localizedDescription);
                    [self uploadPicCallback:nil upImage:img];
                }else {
                    
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        
                        if ([[responseObject objectForKey:@"code"] intValue] == 0) {
                            NSString *responseStr = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:responseObject options:NSJSONWritingPrettyPrinted error:nil] encoding:NSUTF8StringEncoding];
                            NSLog(@"============%@",responseStr);
                            [self uploadPicCallback:responseStr upImage:img];
                        }else {
                            [self uploadPicCallback:nil upImage:img];
                        }
                        
                    }else {
                        [self uploadPicCallback:nil upImage:img];
                    }
                    
                }
            }];
            
        });
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if(![@"public.image" isEqualToString:[info objectForKeyedSubscript:@"UIImagePickerControllerMediaType"]]){
        [picker dismissViewControllerAnimated:YES completion:nil];
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:nil message:@"请选择图片类型进行发送" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    [_textF resignFirstResponder];
    [self autoMoveKeyboard:0];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        imageProcess *upload = [[imageProcess alloc]init];
        [upload uploadImageWithimage:[info objectForKey:UIImagePickerControllerOriginalImage] completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            
            
            
        }];

    });

}

-(void)uploadPicCallback:(NSString*)result file:(NSData*)file{
    NSMutableDictionary *resultDic = [Util StringOrDic2NSDic:result];
    //        NSString *httpPath = Url_httpImage;
    if ([[resultDic objectForKey:@"code"]intValue] == 0) {
        [self sendBufMessageWithType:@"voice" msg:result];
    }
    
    
}

//发送图片消息
-(void)uploadPicCallback:(NSString*)result upImage:(UIImage*)upImage{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (upImage) {
            NSMutableDictionary *resultDic = [Util StringOrDic2NSDic:result];
            NSString *path = [resultDic objectForKey:@"originPath"];
            if ([[resultDic objectForKey:@"code"]intValue] == 0 && path != nil) {
                //保存图片到本地
                [imageProcess saveImageToLocation:UIImageJPEGRepresentation(upImage, 0.5) imageName:path];
                [self sendBufMessageWithType:@"image" msg:result];
            }else{
                NSString *name = [NSString stringWithFormat:@"%@.png" ,[imageProcess getTempImageName]];
                [imageProcess saveImageToLocation:UIImageJPEGRepresentation(upImage, 0.5) imageName:name];
                [self sendBufMessageWithType:@"image" msg:name];
            }
        }
    });
    
}

#pragma mark - 下滑收起键盘
/**
 *  下滑收起键盘
 */
static CGFloat oldTableViewOffsetY;
static CGFloat newTableViewOffsetY;

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    oldTableViewOffsetY=scrollView.contentOffset.y;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    newTableViewOffsetY=scrollView.contentOffset.y;
    if(oldTableViewOffsetY - newTableViewOffsetY > 5){
        [self hideKeyBoard];
    }
}


#pragma mark emotion delegate
//选中表情
-(void)selectEmotion:(NSString*)emotionStr isAutoSend:(BOOL)isAutoSend
{
    if (!isAutoSend) {
        // 替换表情标示string
        emotionStr = [self changeEmotionString:emotionStr];
        _textF.text = [_textF.text stringByAppendingString:emotionStr];
        [_textF updateFrameManully];
    }else{
        [self sendBufMessageWithType:nil msg:[NSString stringWithFormat:@"[%@]",emotionStr]];
    }
    
}
//删除选中的表情（输入框中的表情）
-(void)deleteSelectedEmotion:(NSString *)emotionStr
{
    if ([_textF.text length] >= 4) {
        NSString *lastStr = [_textF.text substringFromIndex:[_textF.text length]-4];
        NSString *reg = @"(\\[)[\u4e00-\u9fa5]{2}(\\])";
        NSPredicate *regTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",reg];
        BOOL isEmoji = [regTest evaluateWithObject:lastStr];
        if (isEmoji) {
            _textF.text = [_textF.text substringToIndex:[_textF.text length]-4];
        }else{
            _textF.text = [_textF.text substringToIndex:[_textF.text length]-1];
        }
    }else if([_textF.text length] >0){
        _textF.text = [_textF.text substringToIndex:[_textF.text length]-1];
    }
    
    [_textF updateFrameManully];
    
}

// 表情转换
- (NSString *)changeEmotionString:(NSString *)string {
    NSArray *newArr = @[@"[困惑]", @"[流泪]", @"[鬼脸]", @"[郁闷]", @"[傲慢]", @"[闭嘴]", @"[惊讶]", @"[流汗]", @"[疑问]", @"[心动]", @"[耍酷]", @"[发怒]", @"[难过]", @"[高兴]", @"[委屈]", @"[鄙视]", @"[瞌睡]", @"[偷笑]", @"[胜利]", @"[再见]", @"[好样]", @"[开心]", @"[鼓掌]", @"[我晕]", @"[握手]", @"[找打]", @"[吃饭]", @"[得意]", @"[好的]", @"[有礼]", @"[惊吓]", @"[发财]", @"[奋斗]", @"[蛋糕]", @"[鲜花]", @"[干杯]", @"[成交]", @"[欢迎]", @"[再会]", @"[通话]"];
    int number;
    if (string.length == 8) {
        number = [[string substringWithRange:NSMakeRange(5, 1)] intValue];
    } else if (string.length == 9) {
        number = [[string substringWithRange:NSMakeRange(5, 2)] intValue];
    }
    string = newArr[number-1];
    
    return string;
}

#pragma mark usually delegate
//发送常用语
-(void)sendUsualSentence:(NSString *)usualStr
{
    [[[self.view subviews]lastObject]removeFromSuperview];
    [_textF becomeFirstResponder];
    [_textF keyboardAppearance];
    _textF.text = [_textF.text stringByAppendingString:usualStr];
    [_textF updateFrameManully];
}
#pragma mark textfield
//按下键盘的return按钮后发送消息
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //    [self sendMessage];
    if (_isRobot) {
        NSString *msg = [textField.text  stringByTrimmingCharactersInSet:
                         [NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (msg.length>0) {
            [self sendBufMessageWithType:@"robot" msg:msg];
            [self getAnswer:msg];
        }else{
            [textField resignFirstResponder];
            [self autoMoveKeyboard:0];
        }
        
    }else{
        [self sendBufMessageWithType:nil msg:_textF.text];
    }
    return YES;
}


// 发消息
- (void)sendBufMessageWithType:(NSString *)type msg:(NSString*)msg {
    
    if (![msg isKindOfClass:[NSNull class]] && [msg length]!=0) {
        
        NSString *packNum = [[NSString alloc] initWithFormat:@"%@", [[[MessageManager alloc] init] getPackNum]];
        Message *message = [MessageManager getBufQSTBody:msg type:type packNumber:packNum isLeave:_isLeave];
        
        if (![@"robot" isEqualToString:type]) {
            if (![startNotice isEqualToString:msg]&&![endNotice isEqualToString:msg] && ![scorerQuest isEqualToString:msg]&& ![vistorQueue isEqualToString:msg] && ![noCustomer isEqualToString:msg]){
                
//                if (!([@"image" isEqualToString:type] && [msg rangeOfString:@"http:"].length<=0)) {
//                    [[IMSocket sharedObject] sendMessage:message];
//                }
                
                if ([type isEqualToString:@"image"]) {
                    if (msg != nil && [msg rangeOfString:@"http:"].length > 0) {
                        [[IMSocket sharedObject] sendMessage:message];
                    }
                }else {
                    [[IMSocket sharedObject] sendMessage:message];
                }
                
            }
        }else{
            packNum = nil;
        }
        
        NSMutableDictionary *msgDic = [Util StringOrDic2NSDic:message.body] ;
        msg = [Util replaceStringHtmlTag:msg];
        msg = [Util replaceStringByReg:@"<([^>]*)>" msg:msg];
        [msgDic setObject:msg forKey:@"msg"];
        
        [self messageView:msgDic and:YES mark:packNum];
        [self.messageArr addObject:msgDic];
        
        [_textF resignFirstResponder];
        if ([[[self.view subviews]lastObject]isKindOfClass:[emotions class]]) {
            [[[self.view subviews]lastObject]removeFromSuperview];
        }else if([[[self.view subviews]lastObject]isKindOfClass:[more class]]){
            [[[self.view subviews]lastObject]removeFromSuperview];
        }
        [self autoMoveKeyboard:0];
        [self.table scrollToRowAtIndexPath:[self lastRowIndexPath] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        _textF.text = nil;
    }
    
    [_textF updateFrameManully];
    
}


//获取当前时间距离1970年的秒数
-(long long)getTimeUtil1970{
    double time = [[NSDate date]timeIntervalSince1970]*1000;
    long long rusutTime =  [[NSNumber numberWithDouble:time]longLongValue];
    return rusutTime;
}
//用uuid作为markid
-(NSString*)markid
{
    return [Util gen_uuid];
}

#pragma mark tableview
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.RichTextSize count];
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellidentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    //消息内容
    UIImageView *imagev = [self.RichTextArr objectAtIndex:indexPath.row];
    if ([[cell.contentView subviews]lastObject] != nil) {
        [[[cell.contentView subviews]lastObject] removeFromSuperview];
    }
    //添加提示动画（如果有的话）
    for (NSMutableDictionary *dic in [self.IndicatorDic allValues]) {
        if ([[dic allValues] indexOfObject:imagev]!= NSNotFound) {
            UIActivityIndicatorView *indicator =(UIActivityIndicatorView *)[dic objectForKey:@"indicator"];
            [indicator startAnimating];
            [imagev addSubview:indicator];
            break;
            
        }
    }
    
    [cell.contentView addSubview:imagev];
    cell.contentView.backgroundColor = bgcolor;
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size =CGSizeFromString([self.RichTextSize objectAtIndex:indexPath.row]);
    return size.height+5;
    
}


//移除所有暂不使用的对象
- (void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"QST" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"LNK" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"ULN" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"VOT" object:nil];
}

//隐藏键盘
-(void)hideKeyBoard{
    [_textF endEditing:YES];
    [self autoMoveKeyboard:0];
}

//------------------------------机器人相关接口--------------------------------------
//获取机器人信息
-(void)getRobotInfo{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[Nationnal shareNationnal].company_id forKey:@"companyId"];
    [dic setObject:[[Nationnal shareNationnal].guestInfo objectForKey:@"robotId"] forKey:@"robotId"];
    
    [HttpService doHttpPostByAsynchronous:[NSString stringWithFormat:@"%@/repository/robotInfo", httpUrl] data:dic isMD5:NO resultHandler:^(NSString *resultStr) {
        if (resultStr !=nil) {
            NSMutableDictionary *robotInfo = [Util StringOrDic2NSDic:resultStr];
            if(robotInfo!=nil){
                [Nationnal shareNationnal].roboitInfo = robotInfo;
                //
                [self messageView:[Util StringOrDic2NSDic: [MessageManager getBufQSTBody:[[robotInfo objectForKey:@"robot"] objectForKey:@"robot_prompt"]  type:@"text" packNumber:nil isLeave:YES].body] and:NO mark:@"received"];
                
                UIView *tips = [self getRobotTips:[[robotInfo objectForKey:@"robot"] objectForKey:@"default_issue"]];
                [self.RichTextArr  addObject:tips];
                [self.RichTextSize addObject:NSStringFromCGSize(tips.frame.size)];
                [_table reloadData];
            }
        }
    }];
 
}

//获取问题建议
-(void)getSuggest:(NSString*)keyword{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[Nationnal shareNationnal].company_id forKey:@"companyId"];
    [dic setObject:[[Nationnal shareNationnal].guestInfo objectForKey:@"robotId"] forKey:@"robotId"];
    [dic setObject:keyword forKey:@"keyword"];
    [dic setObject:@"5" forKey:@"limit"];
    [HttpService doHttpPostByAsynchronous:[NSString stringWithFormat:@"%@/repository/suggest",httpUrl] data:dic isMD5:NO resultHandler:^(NSString *resultStr) {
        
    }];
}

//问题答案
-(void)getAnswer:(NSString*)keyword{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[Nationnal shareNationnal].company_id forKey:@"companyId"];
    [dic setObject:[[Nationnal shareNationnal].guestInfo objectForKey:@"robotId"] forKey:@"robotId"];
    [dic setObject:keyword forKey:@"keyword"];
    [dic setObject:@"5" forKey:@"limit"];
    [dic setObject:[Nationnal shareNationnal].srvid forKey:@"guestId"];
    [dic setObject:[Nationnal shareNationnal].srvid forKey:@"quizzer"];
    
    [HttpService doHttpPostByAsynchronous:[NSString stringWithFormat:@"%@/repository/answer",httpUrl] data:dic isMD5:NO resultHandler:^(NSString *resultStr) {
        if (resultStr != nil) {
            NSDictionary *answerInfo = [Util StringOrDic2NSDic:resultStr];
            if(answerInfo!=nil){
                NSString *resut = [answerInfo objectForKey:@"result"];
                if ([resut isKindOfClass:[NSNull class]]) {
                    [self messageView:[Util StringOrDic2NSDic: [MessageManager getBufQSTBody:[[[Nationnal shareNationnal].roboitInfo objectForKey:@"robot"] objectForKey:@"robot_unknow"]  type:@"text" packNumber:nil isLeave:YES].body] and:NO mark:@"received"];
                }else{
                    [self messageView:[Util StringOrDic2NSDic: [MessageManager getBufQSTBody:[[Util StringOrDic2NSDic:resut] objectForKey:@"content"] type:@"text" packNumber:nil isLeave:YES].body] and:NO mark:@"received"];
                }
            }
        }
    }];
    
    
    //    [Nationnal shareNationnal].roboitInfo
}
//详细答案

-(void)getDetail:(NSString*)issueId{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[Nationnal shareNationnal].company_id forKey:@"companyId"];
    [dic setObject:[[Nationnal shareNationnal].guestInfo objectForKey:@"robotId"] forKey:@"robotId"];
    [dic setObject:issueId forKey:@"issueId"];
    [HttpService doHttpPostByAsynchronous:[NSString stringWithFormat:@"%@/repository/detail",httpUrl] data:dic isMD5:NO resultHandler:^(NSString *resultStr) {
        if (resultStr != nil && [resultStr length]>0) {
            NSDictionary *detailInfo = [Util StringOrDic2NSDic:resultStr];
            if(detailInfo!=nil){
                [self messageView:[Util StringOrDic2NSDic: [MessageManager getBufQSTBody:[[detailInfo objectForKey:@"issue"] objectForKey:@"content"]  type:@"text" packNumber:nil isLeave:YES].body] and:NO mark:@"received"];
            }
        }
    }];
    
    
}
//答案评价

-(void)getVote:(NSString*)issueId helpful:(NSString*)helpful{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:[Nationnal shareNationnal].company_id forKey:@"companyId"];
    [dic setObject:[[Nationnal shareNationnal].guestInfo objectForKey:@"robotId"] forKey:@"robotId"];
    [dic setObject:issueId forKey:@"issueId"];
    [dic setObject:helpful forKey:@"helpful"];
    [HttpService doHttpPostByAsynchronous:[NSString stringWithFormat:@"%@/repository/vote",httpUrl] data:dic isMD5:NO resultHandler:^(NSString *resultStr) {
    }];
    
}




//----------------------------------人工/机器人转换-------------------------------------------------
-(void)change2Robot{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"people"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(change2People)];
    self.navigationItem.title =@"机器人";
    //先结束当前会话
    if([Nationnal shareNationnal].chatid !=nil){
        [[IMSocket sharedObject] sendMessage:[MessageManager getBufULNbody:@"normal"]];
        //        [[ConnBufferService connSocket]sendMessage:[MessageManager getBufULNbody:@"normal"]];
    }
    //    _textF.placeholder =@"如果没有您想要的内容，欢迎输入关键字进行搜索";
    _isRobot = YES;
    [self getRobotInfo];
    
}
-(void)change2People{
    _isRobot = NO;
    //    _textF.placeholder =nil;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:@"robot"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(change2Robot)];
    [[IMSocket sharedObject] sendMessage:[MessageManager getBufLNKbody:[Nationnal shareNationnal].company_id groupId:nil  id6d:nil]];
    //    [[ConnBufferService connSocket] sendMessage:[MessageManager getBufLNKbody:[Nationnal shareNationnal].company_id groupId:nil  id6d:nil]];
    
}


//获取机器人提示音ui
-(UIView*)getRobotTips:(NSArray*)tips{
    //    UITableView *robotTips = [[UITableView alloc]initWithFrame:CGRectMake(16, 2, screenWidth-32, [tips count]*20+20)];
    //    robotTips.dataSource = self;
    //    robotTips.delegate =
    
    if (![tips isKindOfClass:[NSArray class]]) {
        return [UIView new];
    }
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(16, 2, screenWidth-32, [tips count]*25+40)];
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, screenWidth-32, 16)];
    title.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:0.4];
    title.text =@"您可能想要了解的内容";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:14];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(31, 25, screenWidth-62, 0.5)];
    line.backgroundColor = [UIColor colorWithRed:215.0/255.0 green:215.0/255.0 blue:215.0/255.0 alpha:1.0];
    for (int i=0 ;i<[tips count];i++) {
        NSDictionary *dic = tips[i];
        UILabel *tips = [[UILabel alloc]initWithFrame:CGRectMake(31, 40+i*25-5, screenWidth-32, 20)];
        tips.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
        tips.font = [UIFont systemFontOfSize:13];
        tips.text = [dic objectForKey:@"issue_title"];
        tips.tag = [[dic objectForKey:@"issue_id"] intValue];
        [tips addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(getdetailandSend:)]];
        tips.userInteractionEnabled = YES;
        [view addSubview:tips];
    }
    [view addSubview:title];
    [view addSubview:line];
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = 5.0;
    view.backgroundColor = [UIColor colorWithRed:178.0/255.0 green:178.0/255.0 blue:178.0/255.0 alpha:0.1];
    return view;
}

//获取机器人详细问答
-(void)getdetailandSend:(UITapGestureRecognizer*)tap{
    UILabel *lable = (UILabel*)tap.view;
    [self sendBufMessageWithType:@"robot" msg:lable.text];
    [self getDetail:[NSString stringWithFormat:@"%li",lable.tag]];
    NSLog(@"%li",lable.tag);
}

//评分处理
-(void)scoreRequest:(NSNotification*)notify{
    NSDictionary *dic = [Util StringOrDic2NSDic:notify.object];
    if ([[dic objectForKey:@"code"] intValue]==0 ) {
        if ([[dic objectForKey:@"data_type"] intValue]==1 && [[dic objectForKey:@"type"]isEqualToString:@"request"]) {
            //客服请求评分
            [self crmSentance];
        }
    }
    
}


//根据输入文字高度动态改变ui
-(void)heightChange:(CGFloat)height{
    [_toolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(10+height);
    }];
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString: @"\n"]) {
        if(textView.text.length != 0){
            [textView resignFirstResponder];
        }
        [self sendMessage];
        
        return  NO;
    }
    return YES;
}

-(void)sendMessage{
    [_toolView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40);
    }];
    [self sendBufMessageWithType:nil msg:_textF.text ];
}

//发送商品信息
-(void)sendCommodity:(NSDictionary *)commodityDic{
    //    这里需传入这样的字符串
    //    {
    //        titile:"",description:"",url:"",imgUrl:""
    //    }
    NSMutableDictionary *param = [[NSMutableDictionary alloc]init];
    //    这里自行补全
    //    [param setObject:@"" forKey:@"title"];
    //    [param setObject:@"" forKey:@"description"];
    //    [param setObject:@"" forKey:@"url"];
    //    [param setObject:@"" forKey:@"imgUrl"];
    //    [param setObject:@"" forKey:@"type"];
    
    [self sendBufMessageWithType:@"news" msg:[Util dictionary2String:param]];
    
}

//点击商品跳转相应page
-(void)goNewsPage:(NSDictionary *)newsInfo{
    //在这里跳转到相应的页面
    NSLog(@"在这里跳转到相应的页面");
    
}



@end
