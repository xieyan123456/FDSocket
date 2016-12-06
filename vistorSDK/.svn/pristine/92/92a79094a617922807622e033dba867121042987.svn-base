//
//  commodity.m
//  vistorsSDK
//
//  Created by tanghy on 16/8/17.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "commodity.h"
#import "Masonry.h"

@implementation commodity{
    UIImageView *showCommodityImageView;
    UILabel *commodityTitle,*commodityDescription,*price;
    UIButton *sendButton;

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        showCommodityImageView = [[UIImageView alloc]init];
        showCommodityImageView.image = [UIImage imageNamed:@"Shape"];
        [self addSubview:showCommodityImageView];
        [showCommodityImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(10);
            make.left.mas_equalTo(10);
            make.height.mas_equalTo(90);
            make.width.mas_equalTo(90);
        }];
        commodityTitle = [[UILabel alloc]init];
        commodityTitle.text = @"佳沛新西兰阳光超级超级金奇异果(巨无霸PLUS)";
        commodityTitle.font = [UIFont systemFontOfSize:14];
        commodityTitle.numberOfLines = 2;
        [self addSubview:commodityTitle];
        [commodityTitle mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showCommodityImageView.mas_right).offset(16);
            make.top.mas_equalTo(10);
            make.right.mas_equalTo(-10);
        }];
        commodityDescription = [[UILabel alloc]init];
        commodityDescription.text = @"产量稀少 鲜有的浓甜 鲜有";
        commodityDescription.textColor = [UIColor colorWithRed:135.0/255.0 green:135.0/255.0 blue:135.0/255.0 alpha:1.0];
        commodityDescription.font = [UIFont systemFontOfSize:12];
        [self addSubview:commodityDescription];
        [commodityDescription mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showCommodityImageView.mas_right).offset(16);
            make.top.equalTo(commodityTitle.mas_bottom).offset(5);
            make.right.mas_equalTo(-10);
        }];
        
        price = [[UILabel alloc]init];
       
        UIColor *colors = [UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0];
        price.textColor = colors;
        price.font = [UIFont systemFontOfSize:12];
       
        [self addSubview:price];
        [price mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(showCommodityImageView.mas_right).offset(16);
            make.bottom.equalTo(showCommodityImageView.mas_bottom).offset(-5);
            make.right.mas_equalTo(-10);
        }];

        
        sendButton = [[UIButton alloc]init];
        [sendButton setTitle:@"发送商品给客户" forState:UIControlStateNormal];
        sendButton.layer.masksToBounds = YES;
        sendButton.titleLabel.font = [UIFont systemFontOfSize:14];
        sendButton.layer.borderWidth = 0.5;
        sendButton.layer.cornerRadius = 3.0;
        sendButton.layer.borderColor = [[UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0] CGColor];
        [sendButton setTitleColor:[UIColor colorWithRed:255.0/255.0 green:153.0/255.0 blue:51.0/255.0 alpha:1.0] forState:UIControlStateNormal];
        [sendButton addTarget:self action:@selector(sendCommodityInfo) forControlEvents:UIControlEventTouchDown];
        [self addSubview:sendButton];
        [sendButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.equalTo(showCommodityImageView.mas_bottom).offset(16);
            make.height.mas_equalTo(30);
            make.width.mas_equalTo(150);
        }];
        
    }
    self.backgroundColor = [UIColor whiteColor];
    return self;
}

-(void)setCommodityDic:(NSDictionary *)commodityDic{
    //给这几个控件赋值
//    UIImageView *showCommodityImageView;
//    UILabel *commodityTitle,*commodityDescription
    
    NSString *piceStr = [NSString stringWithFormat:@"¥%@",@"168.00"];
    NSMutableAttributedString *attrString=[[NSMutableAttributedString alloc]initWithString:piceStr];
    NSRange range = [piceStr rangeOfString:@"."];
    [attrString addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"HelveticaNeue-Bold" size:20] range:NSMakeRange(1, range.location-1)];
    price.attributedText=attrString;


}

-(void)sendCommodityInfo{
    [self.delegate sendCommodity:_commodityDic];
    [self removeFromSuperview];
}

@end
