//
//  news.m
//  vistorsSDK
//
//  Created by tanghy on 16/8/25.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "news.h"
#import "Masonry.h"

@implementation news{
    UIImageView *newsImageView;
    UILabel *newsTitle,*newsDescription,*price;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(-3, 0, screenWidth-110, 60);
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goNewsPage)]];
        newsImageView = [[UIImageView alloc]init];
        newsImageView.image = [UIImage imageNamed:@"Shape"];
        [self addSubview:newsImageView];
        [newsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(0);
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(60);
            make.width.mas_equalTo(60);
        }];
        newsTitle = [[UILabel alloc]init];
        newsTitle.text = @"新西兰佳沛阳光金奇异果巨无霸(Plus) 金奇异果巨无霸金...";
        newsTitle.font = [UIFont systemFontOfSize:16];
        newsTitle.numberOfLines = 2;
        [self addSubview:newsTitle];
        [newsTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(newsImageView.mas_right).offset(10);
            make.top.mas_equalTo(3);
            make.right.mas_equalTo(10);
        }];
       
        
        price = [[UILabel alloc]init];
        
        UIColor *colors = [UIColor colorWithRed:255.0/255.0 green:169.0/255.0 blue:65.0/255.0 alpha:1.0];
        price.textColor = colors;
        price.font = [UIFont systemFontOfSize:16];
        price.text = @"¥168.00";
        [self addSubview:price];
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(newsImageView.mas_right).offset(10);
            make.bottom.equalTo(newsImageView.mas_bottom);
        }];
        
        
        newsDescription = [[UILabel alloc]init];
        newsDescription.text = @"1斤装";
        newsDescription.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        newsDescription.font = [UIFont systemFontOfSize:16];
        [self addSubview:newsDescription];
        [newsDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(newsImageView.mas_bottom);
            make.left.equalTo(price.mas_right).offset(20);
//            make.centerX.equalTo(newsTitle);
        }];


        
        
    }
    return self;
}


-(void)setNewsInfoDic:(NSDictionary *)newsInfoDic{
    //这里给图文消息控件赋值
    _newsInfoDic = newsInfoDic;
    NSString *titleStr = @"新西兰佳沛阳光金奇异果巨无霸(Plus) 金奇异果巨无霸金金奇异果巨无霸金";
    CGRect title = [self getStringSize:titleStr size:16];
    newsTitle.text = titleStr;
    CGRect description = [self getStringSize:@"1斤装" size:16];
    
    float width = title.size.width+80 > description.size.width+160?title.size.width+80:description.size.width+160;
    
    width = width > screenWidth-110 ? screenWidth-110:width;
    
    self.frame = CGRectMake(0, 0, width, 60);

}

-(void)goNewsPage{
    [self.delegate goNewsPage:_newsInfoDic];
}


-(CGRect)getStringSize:(NSString*)str size:(float)size{
    UIFont *font = [UIFont systemFontOfSize:size];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(screenWidth-180, 200)
                         options:NSStringDrawingUsesLineFragmentOrigin
                      attributes:@{NSFontAttributeName:font}
                      context:nil];
    NSLog(@"%f",rect.size.width);
    return  rect;
}


@end
