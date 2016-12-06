//
//  vioceObject.h
//  53kfiOS
//
//  Created by tagaxi on 15/4/21.
//  Copyright (c) 2015年 wenqing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface vioceObject : NSObject

@property (nonatomic,assign)NSInteger duration;
@property (nonatomic,strong)NSMutableString *wavfile;
@property (nonatomic,strong)NSMutableString *uploadPath;
@property (nonatomic,strong)NSMutableString *amrfile;
-(void)setobjectDuration:(NSInteger)duration wavfile:(NSString*)wavfile amrfile:(NSString*)amrfile;
-(void)setobjectByotherOne:(vioceObject*)voiecO;
@end
