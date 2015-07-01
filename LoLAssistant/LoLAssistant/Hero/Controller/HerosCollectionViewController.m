//
//  HerosCollectionViewController.m
//  HeroVideo-TEXT1
//
//  Created by lanou3g on 15/6/29.
//  Copyright (c) 2015年 Jing. All rights reserved.
//

#define kHeroURL @"http://m.aipai.com/mobile/xifen/collect_action-hero_gameid-25296_menuid-24_appver-a2.4.6_page-1.html"

#import "HerosCollectionViewController.h"
#import "MyCell.h"
#import "Hero.h"
#import "MyHeader.h"
#import "UIImageView+WebCache.h"
#import "VideoTableViewController.h"
#import "MJRefresh.h"
@interface HerosCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
@property (nonatomic,retain)NSString *url;

@property (nonatomic)NSInteger count;

@property (nonatomic,retain)NSMutableArray *heros;//承装假数据

@property (nonatomic,retain)UICollectionViewLayout *layout;
@end

@implementation HerosCollectionViewController





- (void)viewDidLoad {
    [super viewDidLoad];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
//    [self performSelector:NSSelectorFromString(self.method) withObject:nil];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    

    
    //注册cell
    [self.collectionView registerClass:[MyCell class]forCellWithReuseIdentifier:@"Cell"];
    
    //注册 页眉 页脚
    //页眉
    [self.collectionView registerClass:[MyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
    //页脚
    [self.collectionView registerClass:[MyHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer"];

    
    //找到布局对象
    self.layout = (UICollectionViewLayout *)self.collectionViewLayout;
    
    
    //数据请求
    [self URLRequest];
    
    //布局集合视图
    [self layoutCollectionView];
}

//布局URLRequest(数据请求)
- (void)URLRequest
{
    for (int i = 1; i < 7; i++) {
        NSString *a = [kHeroURL substringToIndex:89];
        NSString *newurl = [a stringByAppendingFormat:@"page-%d.html",i];
        NSURL * url = [NSURL URLWithString:newurl];
        NSURLRequest * request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:120];
        NSURLResponse * response = nil;
        NSError * error = nil;
        NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        if (_allkeys ==nil) {
            self.allkeys = [NSMutableArray array];
        }
        
        NSArray *datas = [dic valueForKey:@"data"];
        
        //遍历数组
        for (NSDictionary *dica in datas) {
            //对象封装
            Hero *hero = [[Hero alloc]init];
            //赋值
            [hero setValuesForKeysWithDictionary:dica];
            //放入数组
            [_allkeys addObject:hero];
        }
    }
}

//布局集合视图
- (void)layoutCollectionView
{
//    //UICollectionViewFlowLayout
//    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
//    
    //1.创建collectionView 对象
//    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:self.view.bounds collectionViewLayout:_layout];
    //2.配置属性
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //设置数据源
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    
    //3.添加父视图
    [self.view addSubview:self.collectionView];
    
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

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    // 设置尾部控件的显示和隐藏
//    self.collectionView.footer.hidden = self.heros.count == 0;
//    return self.colors.count;
    return _allkeys.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    Hero *hero = [_allkeys objectAtIndex:indexPath.row];
    //创建对应的URL
    NSURL *imageURL = [NSURL URLWithString:hero.pic];
    //占位图片
    UIImage *placehodlerImage = [UIImage imageNamed:@"2.jpg"];
    [cell.imageView sd_setImageWithURL:imageURL placeholderImage:placehodlerImage];
    
    
    cell.nameLabel.text = hero.title;
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}

//设置   页眉 和 页脚
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //通过kind进行区分 页眉 页脚
    if (kind == UICollectionElementKindSectionHeader)
    {
        //页眉
        MyHeader *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        
        headerView.backgroundColor = [UIColor redColor];
        return headerView;
        
    }else if (kind == UICollectionElementKindSectionFooter)
    {
        //页脚
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"footer" forIndexPath:indexPath];
        footer.backgroundColor = [UIColor whiteColor];
        return footer;
    }
    //否则什么都不是   返回空
    return nil;
}

//灵活布局  UICollectionViewDelegateFlowLayout
//设置 每一个item(cell)大小

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(85, 110);
}

//设置边缘
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置行间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//设置列间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 5;
}

//设置页眉高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(375, 0);
}


//设置页脚高度
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return  CGSizeMake(375, 20);
}

//点击cell
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoTableViewController *videoView = [[VideoTableViewController alloc]init];
    
    Hero *hero = [_allkeys objectAtIndex:indexPath.row];
    
    videoView.url = hero.url;
    videoView.title = hero.title;
    
    [self.navigationController pushViewController:videoView animated:YES];
}

#pragma mark <UICollectionViewDelegate>


// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}



// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}



// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}


@end
