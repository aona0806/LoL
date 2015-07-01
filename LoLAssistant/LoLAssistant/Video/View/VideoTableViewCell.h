//
//  VideoTableViewCell.h
//  HeroVideo-TEXT1
//
//  Created by lanou3g on 15/6/27.
//  Copyright (c) 2015年 Jing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *picView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *adword;

@end
