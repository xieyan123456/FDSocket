//
//  FaceModel.m
//  vistorsSDK
//
//  Created by tanghy on 16/8/8.
//  Copyright © 2016年 tanghy. All rights reserved.
//

#import "FaceModel.h"
#import "SqliteDB.h"

@implementation FaceModel

static FaceModel *faceModel;

+(FaceModel*)shareFaceModel{
    if (faceModel == nil) {
        faceModel = [[FaceModel alloc]init];
        faceModel.packListStrArr = [[NSMutableArray alloc]init];
        faceModel.faceListrArr = [[NSMutableArray alloc]init];
        faceModel.numberOfPack = [[NSMutableArray alloc]init];
        faceModel.pageNum = 0;
        [faceModel initData];
       
    }
    return faceModel;
}

-(void)initData{
    NSArray *packList = [SqliteDB getPackList];
    for (NSDictionary *pack in packList) {
        [_packListStrArr addObject:pack[@"package_name"]];
        NSArray *faceList =[SqliteDB getFaceListByPackId:pack[@"package_id"]];
        NSLog(@"name:%@-------图片个数：%li",pack[@"package_name"],[faceList count]);
        if ([faceList count]!=0) {
            _pageNum += [faceList count]%8==0?[faceList count]/8:(int)[faceList count]/8+1;
        }else{
            _pageNum++;
        }
        [_numberOfPack addObject:[NSNumber numberWithLong:_pageNum]];
        [_faceListrArr addObject:faceList];
    }


}

@end
