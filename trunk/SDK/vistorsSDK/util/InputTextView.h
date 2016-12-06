//
//  InputTextView.h
//  vistorsSDK
//
//  Created by tanghy on 16/8/1.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol InputTextDelegate <NSObject>
-(void)heightChange:(CGFloat)height ;
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text;

@end

@interface InputTextView : UITextView<UITextViewDelegate>

@property(nonatomic,weak)NSObject<InputTextDelegate>  *changeDelegate;

/**
 *  通过键盘输入才会引起界面更新，这个方法主要用于代码拼接字符串后手动更新界面
 */
- (void)updateFrameManully;

@end
