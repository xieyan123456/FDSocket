//
//  vioceObject.m
//  53kfiOS
//
//  Created by tagaxi on 15/4/21.
//  Copyright (c) 2015年 wenqing. All rights reserved.
//

#import "vioceObject.h"

@implementation vioceObject

-(id)init{
   self = [super init];
    if (self) {
        _duration = 0;
        _wavfile = [[NSMutableString alloc]init];
        _uploadPath = [[NSMutableString alloc]init];
        _amrfile = [[NSMutableString alloc]init];
    }
    return self;
}
-(void)setobjectDuration:(NSInteger)duration wavfile:(NSString*)wavfile amrfile:(NSString*)amrfile
{
    _duration = duration;
    [_wavfile setString:wavfile];
    [_amrfile setString:amrfile];
}
-(void)setobjectByotherOne:(vioceObject*)voiecO
{
    _duration = voiecO.duration;
    _wavfile = voiecO.wavfile;
    _amrfile = voiecO.amrfile;
    _uploadPath = voiecO.uploadPath;
}

@end
