//
//  TQRichTextRunEmoji.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 2/28/14.
//  Copyright (c) 2014 fuqiang. All rights reserved.
//

#import "TQRichTextRunEmoji.h"

@implementation TQRichTextRunEmoji

NSMutableArray *emojiArray;
/**
 *  返回表情数组
 */
+ (NSArray *) emojiStringArray
{
    if (emojiArray ==nil && [emojiArray count]==0) {
        emojiArray = [[NSMutableArray alloc]init];
        for (int i=1; i<=73; i++) {
            [emojiArray addObject:[NSString stringWithFormat:@"{53b#%d#}",i]];
            //        [array arrayByAddingObject:[NSString stringWithFormat:@"{53b#%d#}",i]];
        }

    }
    //    NSArray *array = [NSArray arrayWithObjects:@"{53b#1#}",@"{53b#2#}",@"{53b#3#}",@"{53b#4#}",@"{53b#5#}",@"{53b#6#}",@"{53b#7#}",@"{53b#8#}",@"{53b#9#}",@"{53b#10#}",@"{53b#11#}",@"{53b#12#}",@"{53b#13#}",@"{53b#14#}",@"{53b#15#}",@"{53b#16#}",@"{53b#17#}",@"{53b#18#}",@"{53b#19#}",@"{53b#20#}",@"{53b#21#}",@"{53b#22#}",@"{53b#23#}",@"{53b#24#}",@"{53b#25#}",@"{53b#26#}",@"{53b#27#}",@"{53b#28#}",@"{53b#29#}",@"{53b#30#}",@"{53b#31#}",@"{53b#32#}",@"{53b#33#}",@"{53b#34#}",@"{53b#35#}",@"{53b#36#}",@"{53b#37#}",@"{53b#38#}",@"{53b#39#}",@"{53b#40#}",nil];
    
    //表情输入的规则：表情－｛53b#数字＃｝
    
    return emojiArray;
}
/**
 *  解析字符串中url内容生成Run对象
 *
 *  @param attributedString 内容
 *
 *  @return TQRichTextRunURL对象数组
 */
+ (NSMutableArray *)runsForAttributedString:(NSMutableAttributedString *)attributedString
{
    NSString *string      = attributedString.string;
    NSMutableArray *array = [NSMutableArray array];
    NSMutableArray *useLately =[[NSMutableArray alloc]initWithArray:[[NSUserDefaults standardUserDefaults] objectForKey:@"lately"]];
    
    NSString *reg = @"(\\[)[\u4e00-\u9fa5]{2}(\\])";
//     NSString *reg = @"(\\{)53b#(\\d+)#(\\})";
    NSRegularExpression *regular = [NSRegularExpression regularExpressionWithPattern:reg options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matches = [regular matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    while ([matches count]>0){
        NSRange Range = [[matches objectAtIndex:0 ] range];
        NSString *tagString = [string substringWithRange:Range];
        if ([[Nationnal shareNationnal].Pic2face objectForKey:tagString]==nil) {
            break;
        }
        tagString = [[Nationnal shareNationnal].Pic2face objectForKey:tagString];
//        NSArray *arr = [matches objectAtIndex:0];
//        NSRange r1 = [[matches objectAtIndex:0] rangeAtIndex:2];
//        NSString *tagNum = [string substringWithRange:r1];
        NSString *tagNum = [[tagString stringByReplacingOccurrencesOfString:@"{53b#" withString:@""]stringByReplacingOccurrencesOfString:@"#}" withString:@""];
        if ([[TQRichTextRunEmoji emojiStringArray] containsObject:tagString]) {
            
            if (Range.location+Range.length == [string length]) {
                [attributedString replaceCharactersInRange:Range withString:@" \0"];
            }else{
                [attributedString replaceCharactersInRange:Range withString:@" "];
            }
            
            

            TQRichTextRunEmoji *run = [[TQRichTextRunEmoji alloc] init];
            run.range    = NSMakeRange(Range.location, 1);
            run.text     = tagString;
            run.drawSelf = YES;
            [run decorateToAttributedString:attributedString range:run.range];
            if ([useLately count]==0) {
                [useLately addObject:tagNum];
            }else{
                if (![useLately containsObject:tagNum]) {
                    [useLately addObject:tagNum];
                }
            }
            [[NSUserDefaults standardUserDefaults] setObject:useLately forKey:@"lately"];
            [[NSUserDefaults standardUserDefaults]synchronize];

        [array addObject:run];
            NSLog(@"--------------------emotion----------%@",tagString);
        matches = [regular matchesInString:string options:0 range:NSMakeRange(0, [string length])];
        }
        else{
            break;
        }
        
    }
      //解决非换行空格造成不换行
//   string = [string stringByReplacingOccurrencesOfString:@" " withString:@" "];
    
    return array;
}

/**
 *  绘制Run内容
 */
- (void)drawRunWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
   
    NSString *emojiString = [NSString stringWithFormat:@"%@@2x.png",self.text];
    UIImage *image = [UIImage imageNamed:emojiString];
    if (image)
    {
        CGContextDrawImage(context, rect, image.CGImage);
    }
}
//+(NSString*)FileName
//{
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *filename = [[paths objectAtIndex:0]stringByAppendingPathComponent:@"latelyEmo.plist"];
//    return filename;
//}
@end
