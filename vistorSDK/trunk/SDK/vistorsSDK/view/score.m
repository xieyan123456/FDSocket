//
//  score.m
//  vistorsSDK
//
//  Created by tanghy on 16/4/19.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "score.h"
#import "Masonry.h"
#import "Nationnal.h"


@implementation score{
    UIButton *tempBtn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(id)initWithFrame:(CGRect)frame style:(SCORETYPE)style{
   
    if (style == Defaulte){
        return [self initWithFrame:frame];
    }else{
        return [self initView:frame style:style];
    }
    
}




-(id)initView:(CGRect)frame style:(SCORETYPE)style{
    self = [super initWithFrame:frame];
    if (self) {
        if(style == Fruit){
            NSMutableArray *arr = [[NSMutableArray alloc] init];
            
            
            
            UIButton *commit = [UIButton buttonWithType:UIButtonTypeSystem];
            [commit setTitle:@"提交" forState:UIControlStateNormal];
            [commit addTarget:self action:@selector(commitScore:) forControlEvents:UIControlEventTouchDown];
            [commit setTitleColor:[UIColor whiteColor]  forState:UIControlStateNormal];
            [commit setBackgroundColor:[UIColor colorWithRed:253.0/255.0 green:152.0/255.0 blue:64.0/255.0 alpha:1.0]];
            [self addSubview:commit];
            [commit mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(self).offset(-64);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(44);
            }];
            
            UILabel *titleLabel = [[UILabel alloc] init];
            [titleLabel setText:@"请给客服小精灵评个分哦"];
            titleLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:titleLabel];
            [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(44);
            }];
            
            UIButton *close = [[UIButton alloc] init];
            [close setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
            [close addTarget:self action:@selector(closeScore) forControlEvents:UIControlEventTouchDown];
            [self addSubview:close];
            [close mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(0);
                make.left.mas_equalTo(0);
                make.width.mas_equalTo(44);
                make.height.mas_equalTo(44);
            }];
            
            
            
            if ([Nationnal shareNationnal].vote == nil ||[[[Nationnal shareNationnal].vote objectForKey:@"voteList"] isKindOfClass:[NSNull class]] ||  [[[Nationnal shareNationnal].vote objectForKey:@"voteList"] count] ==0) {
                NSArray *buttonArr = [NSArray arrayWithObjects:@"32个赞",@"1个赞",@"0个赞",@"扣个赞", nil];
                NSArray *scoreArr = [NSArray arrayWithObjects:@"32",@"1",@"0",@"-1", nil];
                for (NSString *str in buttonArr) {
                    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                    [dic setObject:str forKey:@"vote_name"];
                    [dic setObject:scoreArr[[buttonArr indexOfObject:str]] forKey:@"score"];
                    [arr addObject:dic];
                }
            }else{
                arr = [[Nationnal shareNationnal].vote objectForKey:@"voteList"];
                titleLabel.text = [[Nationnal shareNationnal].vote objectForKey:@"voteTitle"];
            }


            
            UIView *line = [[UIView alloc]init];
            [line setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0]];
            [self addSubview:line];
            [line mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(titleLabel.mas_bottom);
                make.left.mas_equalTo(0);
                make.right.mas_equalTo(0);
                make.height.mas_equalTo(0.8);
            }];
            
            for (NSMutableDictionary *vote in arr) {
                NSInteger index = [arr indexOfObject:vote];
                
                UIButton *score = [[UIButton alloc] init];
                [score setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [score setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
                score.titleLabel.font = [UIFont systemFontOfSize:14];
                [score setTitle:vote[@"vote_name"] forState:UIControlStateNormal];
                score.tag = index;
                [score addTarget:self action:@selector(scoreNumberSetWithStyle:) forControlEvents:UIControlEventTouchDown];
                [score setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
                score.layer.masksToBounds = YES;
                score.layer.cornerRadius = 3;
                
                
                [self addSubview:score];
                int leftX = 20*(index+1) + index*(screenWidth- (20*(arr.count+1)))/arr.count;
                [score mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.mas_equalTo(leftX);
                    make.top.equalTo(line).offset(25);
                    make.height.mas_equalTo(30);
                    make.width.mas_equalTo((screenWidth- (20*arr.count+1))/arr.count);
                    
                }];
                if (index == 0) {
                    [self scoreNumberSetWithStyle:score];
                }
            }
            
            self.backgroundColor = [UIColor whiteColor];
        
        }
        
    }
    return self;
}


-(id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        //显示title文字
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(22, 21, frame.size.width, 22)];
        title.text = @"请对当前客服人员的服务评分";
        //分割线
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(2, 52, frame.size.width-4, 0.5)];
        line.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        //五个级别评分
        UIButton *scoreBtn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        scoreBtn5.frame = CGRectMake(16, 80, 24, 24);
        scoreBtn5.tag = 5;
        [scoreBtn5 addTarget:self action:@selector(scoreNumberSet:) forControlEvents:UIControlEventTouchDown];
        [scoreBtn5 setImage:[UIImage imageNamed:@"score_select"] forState:UIControlStateNormal];
        tempBtn = scoreBtn5;
        
        UIImageView *scoreImg5 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"feichang"]];
        scoreImg5.frame = CGRectMake(44, 84, 180, 16);
        
        
        
        UIButton *scoreBtn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        scoreBtn4.frame = CGRectMake(16, 116, 24, 24);
        scoreBtn4.tag = 4;
        [scoreBtn4 addTarget:self action:@selector(scoreNumberSet:) forControlEvents:UIControlEventTouchDown];
        [scoreBtn4 setImage:[UIImage imageNamed:@"score_unselect"] forState:UIControlStateNormal];
        UIImageView *scoreImg4 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiaohao"]];
        scoreImg4.frame = CGRectMake(44, 120, 157, 16);
        
        
        UIButton *scoreBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        scoreBtn3.frame = CGRectMake(16, 152, 24, 24);
        scoreBtn3.tag = 3;
        [scoreBtn3 addTarget:self action:@selector(scoreNumberSet:) forControlEvents:UIControlEventTouchDown];
        [scoreBtn3 setImage:[UIImage imageNamed:@"score_unselect"] forState:UIControlStateNormal];
        UIImageView *scoreImg3 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yiban"]];
        scoreImg3.frame = CGRectMake(44, 156, 134, 16);

        
        UIButton *scoreBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        scoreBtn2.frame = CGRectMake(16, 188, 24, 24);
        scoreBtn2.tag = 2;
        [scoreBtn2 addTarget:self action:@selector(scoreNumberSet:) forControlEvents:UIControlEventTouchDown];
        [scoreBtn2 setImage:[UIImage imageNamed:@"score_unselect"] forState:UIControlStateNormal];
        UIImageView *scoreImg2 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"jiaocha"]];
        scoreImg2.frame = CGRectMake(44, 192, 110, 16);

        
        UIButton *scoreBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        scoreBtn1.frame = CGRectMake(16, 224, 24, 24);
        scoreBtn1.tag = 1;
        [scoreBtn1 addTarget:self action:@selector(scoreNumberSet:) forControlEvents:UIControlEventTouchDown];
        [scoreBtn1 setImage:[UIImage imageNamed:@"score_unselect"] forState:UIControlStateNormal];
        UIImageView *scoreImg1 = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"elie"]];
        scoreImg1.frame = CGRectMake(44, 228, 86, 16);

        
        //分割线
        UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(2, 271, frame.size.width-4, 0.5)];
        line2.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0];
        
        UIButton *canelBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        canelBtn.frame = CGRectMake(16, 284, 100, 40);
        [canelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [canelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [canelBtn setBackgroundColor:[UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:1.0]];
        canelBtn.layer.masksToBounds = YES;
        canelBtn.layer.cornerRadius = 5;
        [canelBtn addTarget:self action:@selector(commitScore:) forControlEvents:UIControlEventTouchDown];
        
       
        UIButton *okBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        okBtn.frame = CGRectMake(140, 284, 100, 40);
        [okBtn setTitle:@"提交" forState:UIControlStateNormal];
        [okBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [okBtn setBackgroundColor:[UIColor colorWithRed:101.0/255.0 green:161.0/255.0 blue:49.0/255.0 alpha:1.0]];
        okBtn.layer.masksToBounds = YES;
        okBtn.layer.cornerRadius = 5;
        [okBtn addTarget:self action:@selector(commitScore:) forControlEvents:UIControlEventTouchDown];

        
        [self addSubview:title];
        [self addSubview:line];
        [self addSubview:scoreBtn5];
        [self addSubview:scoreBtn4];
        [self addSubview:scoreBtn3];
        [self addSubview:scoreBtn2];
        [self addSubview:scoreBtn1];
        [self addSubview:line2];
        [self addSubview:okBtn];
        [self addSubview:canelBtn];
        [self addSubview:scoreImg5];
        [self addSubview:scoreImg4];
        [self addSubview:scoreImg3];
        [self addSubview:scoreImg2];
        [self addSubview:scoreImg1];

    }
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 5.0;
    self.backgroundColor = [UIColor whiteColor];
    return  self;

}


-(void)commitScore:(UIButton*)btn{
    NSString *scoreValue =  [NSString stringWithFormat:@"%li",tempBtn.tag];
    if([btn.titleLabel.text isEqualToString:@"取消"]){
        [self.delegate commitScoreNumber:NO voteScore:nil score:scoreValue];
    }else if([btn.titleLabel.text isEqualToString:@"提交"]){
         if ([Nationnal shareNationnal].vote != nil && ![[[Nationnal shareNationnal].vote objectForKey:@"voteList"] isKindOfClass:[NSNull class]]  && [[[Nationnal shareNationnal].vote objectForKey:@"voteList"] count] >0) {
             NSArray *arr = [[Nationnal shareNationnal].vote objectForKey:@"voteList"];
             NSMutableDictionary *dic = [arr objectAtIndex:tempBtn.tag];
             [self.delegate commitScoreNumber:YES voteScore:dic[@"voteScore"] score:dic[@"score"]];
         }else{
             [self.delegate commitScoreNumber:YES voteScore:nil score:scoreValue];
         }
    }


}

-(void)scoreNumberSet:(UIButton*)btn{
    [tempBtn setImage:[UIImage imageNamed:@"score_unselect"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"score_select"] forState:UIControlStateNormal];
    tempBtn = btn;
}

-(void)scoreNumberSetWithStyle:(UIButton*)btn{
    [tempBtn setBackgroundColor:[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0]];
    tempBtn.enabled = YES;
    tempBtn = btn;
    [tempBtn setBackgroundColor:[UIColor colorWithRed:253.0/255.0 green:152.0/255.0 blue:64.0/255.0 alpha:1.0]];
    tempBtn.enabled = NO;
}

-(void)closeScore{
    [self.delegate commitScoreNumber:NO voteScore:@"0" score:@"0"];
}



@end
