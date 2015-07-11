//
//  JGMainViewController.m
//  SampleCollectionViewDemo
//
//  Created by JJetGu on 15-6-19.
//  Copyright (c) 2015年 Free. All rights reserved.
//

#import "JGMainViewController.h"
#import "JGWaterflowView.h"
#import "JGWaterflowViewCell.h"
#import "JGShop.h"
#import "JGShopCell.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface JGMainViewController ()<JGWaterflowViewDataSource, JGWaterflowViewDelegate>
@property (nonatomic, strong)NSMutableArray *shops;
@property (nonatomic, weak) JGWaterflowView *waterflowView;

@end

@implementation JGMainViewController

- (NSMutableArray *)shops
{
    if (_shops == nil) {
        self.shops = [NSMutableArray array];
    }
    return _shops;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 0.初始化数据
    NSArray *newShops = [JGShop objectArrayWithFilename:@"2.plist"];
    [self.shops addObjectsFromArray:newShops];
    
    JGWaterflowView *waterflowView = [[JGWaterflowView alloc]init];
    // 跟随着父控件的尺寸而自动伸缩
    waterflowView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    waterflowView.frame = self.view.bounds;
    waterflowView.dataSource = self;
    waterflowView.delegate = self;
    [self.view addSubview:waterflowView];
    _waterflowView = waterflowView;
    
    // 2.继承刷新控件
    
    __weak UIScrollView *wfView = self.waterflowView;
    
    // 下拉刷新
    wfView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self loadNewShops];
    }];
    
    // 设置自动切换透明度(在导航栏下面自动隐藏)
    wfView.header.autoChangeAlpha = YES;
    
    // 上拉刷新
    wfView.footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self loadMoreShops];
    }];
    
}

- (void)loadNewShops
{
    //只加载一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 加载1.plist
        NSArray *newShops = [JGShop objectArrayWithFilename:@"1.plist"];
        [self.shops insertObjects:newShops atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, newShops.count)]];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        // 刷新瀑布流控件
        [self.waterflowView reloadData];
        
         //停止刷新
        [self.waterflowView.header endRefreshing];
    });
}

- (void)loadMoreShops
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        // 加载3.plist
        NSArray *newShops = [JGShop objectArrayWithFilename:@"3.plist"];
        [self.shops addObjectsFromArray:newShops];
    });
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        // 刷新瀑布流控件
        [self.waterflowView reloadData];
        
        // 停止刷新
        [self.waterflowView.footer endRefreshing];
    });
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    //    NSLog(@"屏幕旋转完毕");
    [self.waterflowView reloadData];
}

#pragma mark - 数据源方法
-(NSUInteger)numberOfCellsInWaterflowView:(JGWaterflowView *)waterflowView
{
    return self.shops.count;
}

- (NSUInteger)numberOfColumnsInWaterflowView:(JGWaterflowView *)waterflowView
{
    if (UIInterfaceOrientationIsPortrait(self.interfaceOrientation)) {
        // 竖屏
        return 3;
    } else {
        return 5;
    }
}

-(JGWaterflowViewCell *)waterflowView:(JGWaterflowView *)waterflowView cellAtIndex:(NSUInteger)index
{
//    static NSString *ID = @"cell";
//    JGWaterflowViewCell *cell = [waterflowView dequeueReusableCellWithIdentifier:ID];
//    if (cell == nil) {
//        cell = [[JGWaterflowViewCell alloc]init];
//        cell.identifier = ID;
//        cell.backgroundColor = HMRandomColor;
//        [cell addSubview:[UIButton buttonWithType:UIButtonTypeContactAdd]];
//        
//        UILabel *label = [[UILabel alloc]init];
//        label.tag = 101;
//        label.frame = CGRectMake(0, 0, 50, 20);
//        [cell addSubview:label];
//    }
//    
//    UILabel *label = (UILabel *)[cell viewWithTag:101];
//    label.text = [NSString stringWithFormat:@"%lu",(unsigned long)index];
    
    JGShopCell *cell = [JGShopCell cellWithWaterflowView:waterflowView];
    
    cell.shop = self.shops[index];
    
    return cell;
}

#pragma mark - 代理方法
-(CGFloat)waterflowView:(JGWaterflowView *)waterflowView heightAtIndex:(NSUInteger)index
{
    JGShop *shop = self.shops[index];
    // 根据cell的宽度 和 图片的宽高比 算出 cell的高度
    return waterflowView.cellWidth * shop.h / shop.w;
}

//-(CGFloat)waterflowView:(JGWaterflowView *)waterflowView marginForType:(JGWaterflowViewMarginType)type
//{
//    switch (type) {
//        case JGWaterflowViewMarginTypeTop:
//            return 30;
//        case JGWaterflowViewMarginTypeBottom:
//            return 50;
//        case JGWaterflowViewMarginTypeLeft:
//            return 10;
//        case JGWaterflowViewMarginTypeRight:
//            return 20;
//        case JGWaterflowViewMarginTypeColumn:
//            return 10;
//            break;
//            
//        default:
//            return 6;
//            break;
//    }
//}

-(void)waterflowView:(JGWaterflowView *)waterflowView didSelectAtIndex:(NSUInteger)index
{
    NSLog(@"点击了第%lu个cell", (unsigned long)index);
}

@end
