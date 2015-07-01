//
//  MainTabBarController.m
//  LoLAssistant
//
//  Created by lanou3g on 15/6/26.
//  Copyright (c) 2015年 lanou3g. All rights reserved.
//

#import "MainTabBarController.h"
#import "NewsListViewController.h"
#import "HerosCollectionViewController.h"
#import "UserListViewController.h"

@interface MainTabBarController ()

@end

@implementation MainTabBarController

- (void)viewDidLoad {
    [super viewDidLoad];
    //配置viewControllers
    [self configViewControllers];
}

//配置viewControllers
- (void)configViewControllers{
    
    //资讯
    NewsListViewController *newsListVC = [[NewsListViewController alloc] init];
    UINavigationController *newsNaVC = [[UINavigationController alloc] initWithRootViewController:newsListVC];
    newsListVC.title = @"资讯";
    
    //英雄
    HerosCollectionViewController *heroListVC = [[HerosCollectionViewController alloc]initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
    UINavigationController *heroNaVC = [[UINavigationController alloc] initWithRootViewController:heroListVC];
    heroListVC.title = @"视频";
    
    //用户
    UserListViewController *userListVC = [[UserListViewController alloc] init];
    UINavigationController *userNaVC = [[UINavigationController alloc] initWithRootViewController:userListVC];
    userListVC.title = @"我的";
    
    //添加
    self.viewControllers = @[newsNaVC,heroNaVC,userNaVC];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
