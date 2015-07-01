//
//  Video.h
//  HeroVideo-TEXT1
//
//  Created by lanou3g on 15/6/27.
//  Copyright (c) 2015年 Jing. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Video : NSObject

@property (nonatomic,copy)NSString *title;//标题
@property (nonatomic,copy)NSString *big;//图片网址
@property (nonatomic,copy)NSString *nickname;//上传者
@property (nonatomic,copy)NSString *flv;//视频地址
@property (nonatomic,copy)NSString *totalTime;//视频时长
@property (nonatomic,copy)NSString *adwords;//简介

@property (nonatomic,retain)NSMutableArray *allkeys;







@end
