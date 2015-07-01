//
//  MyCell.m
//  LessonUI-21-UICollectionView
//
//  Created by lanou3g on 15/6/17.
//  Copyright (c) 2015年 Jing. All rights reserved.
//

#import "MyCell.h"

@implementation MyCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //布局
        //获取当前cell 的高度 和宽度
        CGFloat width = self.frame.size.width;
        CGFloat height = self.frame.size.height;
        //imageView
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, width, height * 4/5)];
        self.imageView.backgroundColor = [UIColor whiteColor];
        self.imageView.layer.cornerRadius = 15;
        self.imageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView];
        
        //textLabel
        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, height * 4/5, width, height/5)];
        self.nameLabel.backgroundColor = [UIColor whiteColor];
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        self.nameLabel.font = [UIFont boldSystemFontOfSize:13.0f];
        [self.contentView addSubview:_nameLabel];
        
    }
    return self;
}






@end
