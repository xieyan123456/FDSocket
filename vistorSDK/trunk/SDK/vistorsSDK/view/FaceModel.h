//
//  FaceModel.h
//  vistorsSDK
//
//  Created by tanghy on 16/8/8.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FaceModel : NSObject

@property(nonatomic,strong) NSMutableArray *packListStrArr;//获取所有表情包名称数组

@property(nonatomic,strong) NSMutableArray *faceListrArr;//获取所有表情包名称数组

@property(nonatomic,strong) NSMutableArray *numberOfPack;//获取每个包分组从多少页开始

@property(assign) NSInteger pageNum;//获取表情显示多少页

+(FaceModel*)shareFaceModel;


@end
