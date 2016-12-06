//
//  emotions.m
//  53kf_iOS
//
//  Created by tagaxi on 14-8-28.
//  Copyright (c) 2014年 Linda. All rights reserved.
//

#import "emotions.h"
#import "Masonry.h"
#import "SqliteDB.h"
#import "FaceModel.h"
#import "UIImageView+WebCache.h"
#define  segmentHeight 36
#define  pageCHeight   30


@implementation emotions

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _model = [FaceModel shareFaceModel];
        
        
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, frame.size.height -segmentHeight)];
        _scrollView.contentSize = CGSizeMake((_model.pageNum+2)*screenWidth, frame.size.height -segmentHeight);
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
//        _scrollView.backgroundColor = bgcolor;
        [self addSubview:_scrollView];
        self.backgroundColor = bgcolor;
        
        _selectedEmotions = [[NSMutableArray alloc]initWithCapacity:20];
        
        
        [self addEmotionsToAll];
        [self addEmotionsToOther];
        
        NSMutableArray *packListStr = [[NSMutableArray alloc]initWithObjects:@"默认表情",nil];
        
        [packListStr addObjectsFromArray:_model.packListStrArr];

        
        _segment = [[UISegmentedControl alloc]initWithItems:packListStr];
        CGFloat _segmentWidth = [packListStr count]*120 > frame.size.width ?  [packListStr count]*120:frame.size.width;
        [_segment setFrame:CGRectMake(0, 0, _segmentWidth, segmentHeight)];
        
        //设置背景颜色，以及选中文字颜色
       [_segment setTintColor:[UIColor colorWithRed:221.0/255.0 green:221.0/255.0 blue:221.0/255.0 alpha:1.0]];
        UIColor *unselect = [UIColor colorWithRed:85.0/255.0 green:85.0/255.0 blue:85.0/255.0 alpha:1.0];
        NSShadow *shadow = [[NSShadow alloc]init];
        shadow.shadowColor = [UIColor colorWithRed:170.0/255.0 green:170.0/255.0 blue:170.0/255.0 alpha:1.0];
        shadow.shadowOffset = CGSizeMake(0, 0);
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:RedDif,NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0f],NSFontAttributeName ,shadow,NSShadowAttributeName ,nil];
        [_segment setTitleTextAttributes:dic forState:UIControlStateSelected];
        NSDictionary *dic0 = [NSDictionary dictionaryWithObjectsAndKeys:unselect,NSForegroundColorAttributeName,[UIFont systemFontOfSize:12.0f],NSFontAttributeName ,shadow,NSShadowAttributeName ,nil];
        [_segment setTitleTextAttributes:dic0 forState:UIControlStateNormal];
        
        
        [_segment addTarget:self action:@selector(segmentAction:) forControlEvents:UIControlEventValueChanged];
        _segment.selectedSegmentIndex = 0;
        
//        [self addSubview:_segment];
        
        UIScrollView  *packScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, frame.size.height-segmentHeight, frame.size.width, segmentHeight)];
        packScrollView.contentSize = _segment.frame.size;
        packScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:packScrollView];
        [packScrollView addSubview:_segment];
        
        _pageC = [[UIPageControl alloc]init];
        _pageC.numberOfPages = 2;
        _pageC.pageIndicatorTintColor = [UIColor colorWithRed:244.0/255.0 green:244.0/255.0 blue:244.0/255.0 alpha:1];

        _pageC.currentPageIndicatorTintColor = RedDif;
        _pageC.userInteractionEnabled = NO;
        [_scrollView scrollRectToVisible:CGRectMake(frame.size.width, 0, frame.size.width,_scrollView.frame.size.height) animated:YES];
        _pageC.currentPage = 0;
//        [self addSubview:_pageC];
        
//        [_pageC mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(_segment.mas_top);
//            make.centerX.equalTo(self);
//            make.width.mas_equalTo(100);
//            make.height.mas_equalTo(20);
//        }];

        
         [_scrollView scrollRectToVisible:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    }
    return self;
}
-(void)sendMessages
{
    
    [_delegate sendMessage];
}


-(void)addEmotionsToAll
{
    _allEmtions= [[NSArray alloc]init];
    _allEmtions = @[@"{53b#1#}",@"{53b#2#}",@"{53b#3#}",@"{53b#4#}",@"{53b#5#}",@"{53b#6#}",@"{53b#7#}",@"{53b#8#}",@"{53b#9#}",@"{53b#10#}",@"{53b#11#}",@"{53b#12#}",@"{53b#13#}",@"{53b#14#}",@"{53b#15#}",@"{53b#16#}",@"{53b#17#}",@"{53b#18#}",@"{53b#19#}",@"{53b#20#}",@"trash-bin",@"{53b#21#}",@"{53b#22#}",@"{53b#23#}",@"{53b#24#}",@"{53b#25#}",@"{53b#26#}",@"{53b#27#}",@"{53b#28#}",@"{53b#29#}",@"{53b#30#}",@"{53b#31#}",@"{53b#32#}",@"{53b#33#}",@"{53b#34#}",@"{53b#35#}",@"{53b#36#}",@"{53b#37#}",@"{53b#38#}",@"{53b#39#}",@"{53b#40#}",@"trash-bin"];
    
    
    int i = 0;
    for (NSString *str in _allEmtions) {
        
        int row = ((int)(i/7))%3;
        int col = i%7;
        int page = (int)i/21;
        int width = self.frame.size.width/7;
        int height = (self.frame.size.height-66)/3;
        UIView *bg  = [[UIView alloc]initWithFrame: CGRectMake(width*col+page*self.frame.size.width, row*height, width, height)];
        bg.backgroundColor = [UIColor clearColor];
        UIButton *faceImg = [[UIButton alloc] init];//[UIButton buttonWithType:UIButtonTypeSystem];
        [faceImg setImage:[[UIImage imageNamed:str] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        faceImg.tag = 1000000 + i;
        [bg addSubview:faceImg];
        [faceImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(bg);
            make.centerY.equalTo(bg);
            make.width.mas_equalTo(2*width/3);
            make.height.mas_equalTo(2*width/3);
        }];
        [faceImg addTarget:self action:@selector(selecteEmotionByPress:) forControlEvents:UIControlEventTouchDown];
        [_scrollView addSubview:bg];
        i++;
    }

}

-(void)addEmotionsToOther{
    int i=0;
    for (NSArray *arr in _model.faceListrArr) {
        int index = 0;
        for (NSDictionary *dic in arr) {
            int row = ((int)(index/4))%2;
            int col = index%4;
            int page = i==0?index/8+2:(int)index/8+2+[[_model.numberOfPack objectAtIndex:i-1] intValue];
            int width = self.frame.size.width/4;
            int height = (self.frame.size.height-36)/2;
            
            UIView *bg  = [[UIView alloc]initWithFrame: CGRectMake(width*col+page*self.frame.size.width, row*height, width, height)];
            bg.backgroundColor = [UIColor clearColor];
            UIImageView *faceImg = [[UIImageView alloc] init];
            [faceImg sd_setImageWithURL:dic[@"face_path"] placeholderImage:[UIImage imageNamed:@"{53b#61#}"]];
            faceImg.userInteractionEnabled = YES;
            faceImg.tag = [dic[@"face_id"] intValue];
//            faceImg.tag = 100 + i;
            [bg addSubview:faceImg];
            [faceImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(bg);
                make.centerY.equalTo(bg);
                make.width.mas_equalTo(2*width/3);
                make.height.mas_equalTo(2*width/3);
            }];
            [faceImg addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectFace:)]];
            
            [_scrollView addSubview:bg];
            
            index++;
        }
        i++;
    }


}



-(void)selecteEmotionByPress:(UIButton*)button
{
    NSUInteger  index = button.tag - 1000000;
    if([_allEmtions[index] isEqualToString:@"trash-bin"]){
        [_delegate deleteSelectedEmotion:@"trash-bin"];
    }else{
        [_delegate selectEmotion: _allEmtions[index] isAutoSend:NO];
    }
}

-(void)selectFace:(UITapGestureRecognizer*)tap{
    NSLog(@"点击的图片的id为%li",tap.view.tag);
    NSDictionary *faceInfo = [SqliteDB getFaceByFaceId:[NSString stringWithFormat:@"%li",tap.view.tag]];
    
     [_delegate selectEmotion: faceInfo[@"parsing_rules"] isAutoSend:YES];

}

-(NSString*)FileName
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *filename = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"latelyEmo.plist"];
    return filename;
}

-(void)segmentAction:(UISegmentedControl*)seg
{
    seg = _segment;
    NSInteger index = seg.selectedSegmentIndex;
    if(index == 0){
        [_scrollView scrollRectToVisible:CGRectMake(0, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    }else{
        CGFloat offsetWith = index==1?2*_scrollView.frame.size.width:([_model.numberOfPack[index-2] floatValue]+2)*_scrollView.frame.size.width;
        [_scrollView scrollRectToVisible:CGRectMake(offsetWith, 0, _scrollView.frame.size.width, _scrollView.frame.size.height) animated:YES];
    }

}
#pragma scrollView 
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.x < 2*self.frame.size.width) {
        _pageC.currentPage = scrollView.contentOffset.x/self.frame.size.width;
        _segment.selectedSegmentIndex = 0;
//        if ([[self subviews]indexOfObject:_pageC]==NSNotFound) {
//            [self addSubview:_pageC];
//        }
    }else{
        int page = (int)scrollView.contentOffset.x/self.frame.size.width-1;
        int i = 0;
        for (id pageNum in _model.numberOfPack) {
            if (page <= [pageNum intValue]) {
                break;
            }
            i++;
        }
        _segment.selectedSegmentIndex = i+1;//[_model.numberOfPack indexOfObject:[NSNumber numberWithInt:page]]+1;
    }



}



@end
