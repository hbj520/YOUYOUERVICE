//
//  AllActivityViewController.m
//  ERVICE
//
//  Created by apple on 3/22/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "AllActivityViewController.h"

#import "Hexcolor.h"
#import "ActivityHeaderTableViewCell.h"
#import "ActivityContentTableViewCell.h"
#import "ActivityDetailViewController.h"
#import "SDCycleScrollView.h"

#import "ActivityModel.h"
#import "HomepageBannerModel.h"
#import <MJRefresh.h>
static NSString *reuseHeaderId = @"headerId";
static NSString *reuseContentId = @"contentId";
@interface AllActivityViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate>
{
    SDCycleScrollView *_headerView;
    NSInteger _page;
    NSMutableArray *bannerDataSource;
    NSMutableArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *allActivityTableView;

@end

@implementation AllActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //下载数据
    [self loadBannersData];
    [self loadDataWithPage:0];
    [self configTableView];
    
    //添加刷新
    [self addRefresh];
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
#pragma mark - PrivateMethod
- (void)addRefresh{
    __weak AllActivityViewController *weakself = self;
    self.allActivityTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadDataWithPage:0];
    }];
}
- (void)configTableView{
    self.allActivityTableView.delegate = self;
    self.allActivityTableView.dataSource = self;
    [self.allActivityTableView registerClass:[ActivityHeaderTableViewCell class] forCellReuseIdentifier:reuseHeaderId];
    [self.allActivityTableView registerClass:[ActivityContentTableViewCell class] forCellReuseIdentifier:reuseContentId];
    
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return dataSource.count;
    }
    return -1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ActivityHeaderTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityHeaderTableViewCell" owner:self options:nil] lastObject];
        return cell;
    }else if (indexPath.section == 1){
        ActivityContentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityContentTableViewCell" owner:self options:nil] lastObject];
        ActivityModel *model = [dataSource objectAtIndex:indexPath.row];
        [cell configWithData:model];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 35;
    }else if (indexPath.section == 1){
        return 80;
    }
    return -1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    ActivityModel *model = [dataSource objectAtIndex:indexPath.row];
    cell.selected = NO;
    [self performSegueWithIdentifier:@"AllactivityDetailSegue" sender:model.activityId];
   
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 160;
    }
    return 0;
}
#pragma mark -SDCycleScrollViewDelegate
//点击头部滚动视图
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

#pragma mark - PrivateMethod
- (void)configPageViews{
    NSMutableArray *imagArray = [NSMutableArray array];
    for (HomepageBannerModel *model in bannerDataSource) {
        [imagArray addObject:model.imageUrl];
    }
    _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,ScreenWidth,160) imageURLStringsGroup:imagArray];
    _headerView.delegate = self;
    
    
}
- (void)loadBannersData{
    [[MyAPI sharedAPI] loadAllActivityBannerWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            bannerDataSource = arrays;
        }else{
            
        }
        
    } errorResult:^(NSError *enginerError) {
        
    }];
}
- (void)loadDataWithPage:(NSInteger)page{
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *pageString = [NSString stringWithFormat:@"%ld",page];
    [[MyAPI sharedAPI] loadAllActivityWithPage:pageString result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            dataSource = arrays;
            [self showHint:@"加载完成!!"];
            [self configPageViews];
            [self.allActivityTableView reloadData];
            [self hideHud];
        }else{
            [self showHint:@"加载失败!!"];
            [self hideHud];
        }
        [self.allActivityTableView.mj_header endRefreshing];
    } errorBlock:^(NSError *enginerError) {
        [self showHint:@"加载出错!!"];
        [self hideHud];
        [self.allActivityTableView.mj_header endRefreshing];
    }];
}
#pragma mark - XLSwipeContainerItemDelegate

-(NSString *)nameForSwipeContainer:(XLSwipeContainerController *)swipeContainer
{
    return @"全部活动";
}

-(UIColor *)colorForSwipeContainer:(XLSwipeContainerController *)swipeContainer
{
    return [UIColor colorWithHexString:@"FF5000"];
}
#pragma mark - prepareMethod
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    ActivityDetailViewController *detailVC = (ActivityDetailViewController *)segue.destinationViewController;
    detailVC.activityId = (NSString *)sender;
}
@end
