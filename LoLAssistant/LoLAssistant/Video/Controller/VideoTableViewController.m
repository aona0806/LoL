//
//  VideoTableViewController.m
//  HeroVideo-TEXT1
//
//  Created by lanou3g on 15/6/27.
//  Copyright (c) 2015年 Jing. All rights reserved.
//

#import "VideoTableViewController.h"
#import "VideoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "Video.h"

#import "MJRefresh.h"

#import <MediaPlayer/MediaPlayer.h>

@interface VideoTableViewController ()
@property (nonatomic,retain)NSMutableArray *allkeys;
@property (nonatomic,retain)NSMutableArray *fakeData;
@property (nonatomic)NSInteger count;
@property (nonatomic,retain)NSString *flv;

@property (nonatomic,retain)MPMoviePlayerViewController *moviePlayerViewController;
@end

@implementation VideoTableViewController

/**
 *  数据的懒加载
 */
- (NSMutableArray *)fakeData
{
    if (!_fakeData) {
        self.fakeData = [NSMutableArray array];
        
//        for (int i = 0; i<10; i++) {
//            [self.fakeData addObject:_allkeys[i]];
//        }
    }
    return _fakeData;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"VideoTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
    _count = 1;
    
    [self setupRefresh];
    
//    [self URLRequest];
}

- (void)dealloc
{
    NSLog(@"MJTableViewController--dealloc---");
}



/**
 *  集成刷新控件
 */
- (void)setupRefresh
{
    // 1.下拉刷新(进入刷新状态就会调用self的headerRereshing)
    [self.tableView addHeaderWithTarget:self action:@selector(headerRereshing)];
#warning 自动刷新(一进入程序就下拉刷新)
    [self.tableView headerBeginRefreshing];
    
    // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
    [self.tableView addFooterWithTarget:self action:@selector(footerRereshing)];
    
    // 设置文字(也可以不设置,默认的文字在MJRefreshConst中修改)
    self.tableView.headerPullToRefreshText = @"下拉可以刷新了";
    self.tableView.headerReleaseToRefreshText = @"松开马上刷新了";
    self.tableView.headerRefreshingText = @"刷新中,请稍等";
    
    self.tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    self.tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    self.tableView.footerRefreshingText = @"加载中,请稍等";
}

#pragma mark 开始进入刷新状态
- (void)headerRereshing
{
    _count = 1;
    [_allkeys removeAllObjects];
    [_fakeData  removeAllObjects];
    [self URLRequest];
    // 1.添加假数据
    for (int i = 0; i<_allkeys.count; i++) {
        [self.fakeData insertObject:_allkeys[_allkeys.count - 1 - i] atIndex:0];
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView headerEndRefreshing];
    });
}

- (void)footerRereshing
{
    _count++;
    [self URLRequest];
    // 1.添加假数据
    for (int i = 0; i< _allkeys.count; i++) {
        [self.fakeData addObject:_allkeys[_allkeys.count - 1 - i]];
    }
    
    // 2.2秒后刷新表格UI
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新表格
        [self.tableView reloadData];
        
        // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
        [self.tableView footerEndRefreshing];
    });
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//布局URLRequest(数据请求)
- (void)URLRequest
{
    [self.allkeys removeAllObjects];
    //截取
    NSString *a = [_url substringToIndex:74];
    //转换
    NSString *b = [self.title stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    //拼接
    NSString *c = [a stringByAppendingString:b];
    NSString *d = [c stringByAppendingString:@"_op-AND_appver-a2.4.6_"];
    NSString *newurl = [d stringByAppendingFormat:@"page-%ld.html",_count];
    
    NSURL * url = [NSURL URLWithString:newurl];
    NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:120];
    NSURLResponse * response = nil;
    NSError * error = nil;
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    if (_allkeys ==nil) {
        self.allkeys = [NSMutableArray array];
    }
    
    NSArray *datas = [dic valueForKey:@"video"];

    
    //遍历数组
    for (NSDictionary *dica in datas) {
        
        //对象封装
        Video *hero = [[Video alloc]init];
        //赋值
        [hero setValuesForKeysWithDictionary:dica];
        //放入数组
        [_allkeys addObject:hero];
    }
}


#pragma mark - Table view data source
//分区
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _fakeData.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    VideoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    Video *video = [_fakeData objectAtIndex:indexPath.row];
    
    //创建对应的URL
    NSURL *imageURL = [NSURL URLWithString:video.big];
    //占位图片
    UIImage *placehodlerImage = [UIImage imageNamed:@"2.jpg"];
    cell.picView.layer.cornerRadius = 15;
    cell.picView.layer.masksToBounds = YES;
    [cell.picView sd_setImageWithURL:imageURL placeholderImage:placehodlerImage];
    
    //赋值
    cell.adword .text = video.adwords;
    cell.title.text = video.title;
    cell.nickname.text = video.nickname;
    cell.time.text = video.totalTime;
    
    return cell;
}

//Row 的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}



//点击
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Video *video = [_fakeData objectAtIndex:indexPath.row];
    _flv = video.flv;

    //提示视图控制器
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"请选择" message:nil preferredStyle:(UIAlertControllerStyleActionSheet)];
    //添加时间
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"播放" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [self createMPPlayerController:_flv];
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"下载" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"收藏" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
    }];
    UIAlertAction *action4 = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        [alertVC dismissMoviePlayerViewControllerAnimated];
    }];
    
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:action3];
    [alertVC addAction:action4];
    //模态出提示框
    [self presentViewController:alertVC animated:YES completion:nil];
    
//    [self createMPPlayerController:_flv];
}


//视频播放
- (void)createMPPlayerController:(NSString *)sFileNamePath
{
    NSString *a = [[NSString alloc]initWithString:_flv];
    self.moviePlayerViewController = [[MPMoviePlayerViewController alloc]initWithContentURL:[NSURL URLWithString:a]];
    
    [self.view addSubview:self.moviePlayerViewController.view];
    
    [self.moviePlayerViewController.moviePlayer prepareToPlay];
    
    [self presentMoviePlayerViewControllerAnimated:self.moviePlayerViewController];
    
    [self.moviePlayerViewController.moviePlayer setControlStyle:MPMovieControlStyleFullscreen];
    
    [self.moviePlayerViewController.view setFrame:self.view.frame];
    
    [self.moviePlayerViewController.view setBackgroundColor:[UIColor clearColor]];
    [[NSNotificationCenter defaultCenter]addObserver:self selector: @selector(movieFinishedCallback:) name:MPMoviePlayerPlaybackDidFinishNotification object :self.moviePlayerViewController.moviePlayer ];
    
}

-(void)movieFinishedCallback:(NSNotification*)notify
{
    MPMoviePlayerController * theMovie = [notify  object ];
    [[ NSNotificationCenter defaultCenter]removeObserver:self name : MPMoviePlayerPlaybackDidFinishNotification object :theMovie];
    [self dismissMoviePlayerViewControllerAnimated ];
}





@end
