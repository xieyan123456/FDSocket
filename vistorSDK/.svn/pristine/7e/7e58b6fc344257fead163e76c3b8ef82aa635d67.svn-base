//
//  InputTextView.m
//  vistorsSDK
//
//  Created by tanghy on 16/8/1.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "InputTextView.h"



@implementation InputTextView{

    CGFloat max_height,temp_height;

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
        self.layer.borderWidth = 1.0;
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 5.0;
        self.layer.borderColor = [[UIColor colorWithRed:152.0/255.0 green:152.0/255.0 blue:152.0/255.0 alpha:1.0] CGColor];
        self.showsVerticalScrollIndicator = NO;
        self.delegate = self;
        max_height = 100;
    }
    return self;
}

- (void)updateFrameManully {
    [self textViewDidChange:self];
}

-(void)textViewDidChange:(UITextView *)textView{
    CGRect bounds =  textView.bounds;
    CGSize size =  [self sizeThatFits:CGSizeMake(textView.frame.size.width, FLT_MAX)];
    CGFloat newHeight = size.height > max_height ? max_height:size.height;
    bounds.size = CGSizeMake(bounds.size.width, newHeight);
    if (temp_height != newHeight) {
        temp_height = newHeight;
        [self.changeDelegate heightChange:newHeight];
        textView.bounds = bounds;
    }
    
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    return  [self.changeDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
}

@end
