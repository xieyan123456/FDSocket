//
//  more.m
//  53kfiOS
//
//  Created by tagaxi on 15/3/24.
//  Copyright (c) 2015年 wenqing. All rights reserved.
//

#import "more.h"

@implementation more
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        /*
        
//        _pictures = [[UIButton alloc]initWithFrame:CGRectMake(25, 30, 60, 60)];
//        [_pictures setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
//        [_pictures addTarget:self action:@selector(PhotoesFromPhone:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_pictures];
        
         */
        self.backgroundColor = bgcolor;
        CGFloat spaceX=(screenWidth - 3 * 60) / 4;
//        CGFloat spaceY=(frame.size.height - 60 - 15) / 2;
        CGFloat spaceY=30;
        _voice = [[UIButton alloc]initWithFrame:CGRectMake(2 * spaceX + 60, spaceY, 60, 60)];
        [_voice setBackgroundImage:[UIImage imageNamed:@"photo_btn"] forState:UIControlStateNormal];
        [_voice addTarget:self action:@selector(voice:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *voiceText =[[UILabel alloc]initWithFrame:CGRectMake(2 * spaceX + 60, spaceY+60, 60, 15)];
        voiceText.textAlignment = NSTextAlignmentCenter;
        voiceText.font = [UIFont systemFontOfSize:12];
        voiceText.text = @"图片";
        [self addSubview:_voice];
        [self addSubview:voiceText];
         
//        _cameral = [[UIButton alloc]initWithFrame:CGRectMake(130, 30, 60, 60)];
//        [_cameral setImage:[UIImage imageNamed:@"camera"] forState:UIControlStateNormal];
//        [_cameral addTarget:self action:@selector(Cameral:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_cameral];
        _cameral = [[UIButton alloc]initWithFrame:CGRectMake(spaceX, spaceY, 60, 60)];
        [_cameral setImage:[UIImage imageNamed:@"camel_btn"] forState:UIControlStateNormal];
        [_cameral addTarget:self action:@selector(Cameral:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *photoText =[[UILabel alloc]initWithFrame:CGRectMake(spaceX, spaceY+60, 60, 15)];
        photoText.textAlignment = NSTextAlignmentCenter;
        photoText.font = [UIFont systemFontOfSize:12];
        photoText.text = @"拍照";
        [self addSubview:_cameral];
        [self addSubview:photoText];
        
        
//        _voice = [[UIButton alloc]initWithFrame:CGRectMake(25, 30, 60, 60)];
//        [_voice setImage:[UIImage imageNamed:@"nopress"] forState:UIControlStateNormal];
//        [_voice addTarget:self action:@selector(voice:) forControlEvents:UIControlEventTouchUpInside];
//        [self addSubview:_voice];
        
//        _crmButton = [[UIButton alloc]initWithFrame:CGRectMake(235, 30, 60, 60)];
//        [_crmButton setImage:[UIImage imageNamed:@"photo"] forState:UIControlStateNormal];
//        [_crmButton addTarget:self action:@selector(crmAction:) forControlEvents:UIControlEventTouchUpInside];
        _crmButton = [[UIButton alloc]initWithFrame:CGRectMake(3 * spaceX + 2 * 60, spaceY, 60, 60)];
        [_crmButton setImage:[UIImage imageNamed:@"order_btn"] forState:UIControlStateNormal];
        [_crmButton addTarget:self action:@selector(crmAction:) forControlEvents:UIControlEventTouchUpInside];
        UILabel *crmText =[[UILabel alloc]initWithFrame:CGRectMake(3 * spaceX + 2 * 60, spaceY + 60, 60, 15)];
        crmText.textAlignment = NSTextAlignmentCenter;
        crmText.font = [UIFont systemFontOfSize:12];
        crmText.text = @"我的订单号";
        
        if ([Nationnal shareNationnal].isLogin) {
            [self addSubview:_crmButton];
            [self addSubview:crmText];
        }
        
    }
    return self;
}
//-(void)PhotoesFromPhone:(UIButton*)but
//{
//    NSString*type = @"library";
//    [_delegate pictureFromCameral:type];
//}
-(void)Cameral:(UIButton*)but
{
    [_delegate takePhotoes:@"cameral"];

//    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"拍照" otherButtonTitles:@"从手机相册选择", nil];
//    [sheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        NSString*type = @"library";
        [_delegate pictureFromCameral:type];
    }
    if (buttonIndex == 0) {
        NSString*type = @"cameral";
        [_delegate takePhotoes:type];

    }

}



-(void)voice:(UIButton*)but
{
    [_delegate takePhotoes:@"library"];
}

-(void)crmAction:(UIButton *)but
{
    [_delegate crmSentance];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
