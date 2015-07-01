//
//  MyHeader.m
//  LessonUI-21-UICollectionView
//
//  Created by lanou3g on 15/6/17.
//  Copyright (c) 2015年 Jing. All rights reserved.
//

#import "MyHeader.h"

@implementation MyHeader


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //title
        self.title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width / 4, self.frame.size.height * 2/3)];
        //让title居中
        self.title.center = self.center;
        self.title.textAlignment = NSTextAlignmentCenter;
        
        //添加父视图
        [self addSubview:_title];
    }
    return self;
}




@end
