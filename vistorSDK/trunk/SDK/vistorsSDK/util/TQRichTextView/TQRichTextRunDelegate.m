//
//  TQRichTextRunDelegate.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 2/28/14.
//  Copyright (c) 2014 fuqiang. All rights reserved.
//

#import "TQRichTextRunDelegate.h"

@implementation TQRichTextRunDelegate

/**
 *  向字符串中添加相关Run类型属性
 */
- (void)decorateToAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    [super decorateToAttributedString:attributedString range:range];
   
    CTRunDelegateCallbacks callbacks;
    callbacks.version    = kCTRunDelegateVersion1;
    callbacks.getAscent  = TQRichTextRunDelegateGetAscentCallback;
    callbacks.getDescent = TQRichTextRunDelegateGetDescentCallback;
    callbacks.getWidth   = TQRichTextRunDelegateGetWidthCallback;
    callbacks.dealloc    = TQRichTextRunDelegateDeallocCallback;

    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&callbacks, (__bridge void*)self);
    [attributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:range];
    CFRelease(runDelegate);
    
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)[UIColor clearColor].CGColor range:range];
    
    
}

#pragma mark - RunCallback

//- (void)richTextRunDealloc
//{
//    
//}

- (CGFloat)richTextRunGetAscent
{
    return [UIImage imageNamed:@"{53b#1#}"].size.height+15;
//    return self.font.ascender>37?self.font.ascender:37;
  
}

- (CGFloat)richTextRunGetDescent
{
    return 0;
//    return self.font.descender>1?self.font.descender:1;
  
}

- (CGFloat)richTextRunGetWidth
{
 
    return [UIImage imageNamed:@"{53b#1#}"].size.width+15;
//    return (self.font.ascender - self.font.descender)>17?(self.font.ascender - self.font.descender):17;
   
}

#pragma mark - RunDelegateCallback

void TQRichTextRunDelegateDeallocCallback(void *refCon)
{
//  TQRichTextRunDelegate *run =(__bridge TQRichTextRunDelegate *) refCon;
//    
//   [run richTextRunDealloc];
}

//--上行高度
CGFloat TQRichTextRunDelegateGetAscentCallback(void *refCon)
{
    TQRichTextRunDelegate *run =(__bridge TQRichTextRunDelegate *) refCon;
    
    return [run richTextRunGetAscent];
    
    
}

//--下行高度
CGFloat TQRichTextRunDelegateGetDescentCallback(void *refCon)
{
    TQRichTextRunDelegate *run =(__bridge TQRichTextRunDelegate *) refCon;
    
    return [run richTextRunGetDescent];
  
}

//-- 宽
CGFloat TQRichTextRunDelegateGetWidthCallback(void *refCon)
{
    TQRichTextRunDelegate *run =(__bridge TQRichTextRunDelegate *) refCon;
    
    return [run richTextRunGetWidth];
    
}

@end
