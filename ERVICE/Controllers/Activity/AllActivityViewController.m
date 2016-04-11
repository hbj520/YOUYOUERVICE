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
@interface AllActivityViewController ()<UITableViewDataSource,UITableViewDelegate,SDCycleScrollViewDelegate,UIAlertViewDelegate>
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
    _page = 1;
    [self loadBannersData];
    [self loadDataWithPage:_page];
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
        [weakself loadBannersData];
        [weakself loadDataWithPage:0];
        _page = 1;
        if (dataSource) {
            [dataSource removeAllObjects];
        }
    }];
    self.allActivityTableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakself loadDataWithPage:_page];
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
    if (section == 0) {
        return 10;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 40;
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
        return 116;
    }
    return 0;
}
#pragma mark -SDCycleScrollViewDelegate
//点击头部滚动视图
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}

#pragma mark - PrivateMethod
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
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
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (success) {
            if (!dataSource) {
                dataSource = [NSMutableArray array];
            }
            [dataSource addObjectsFromArray:arrays];
            [self configPageViews];
            [self.allActivityTableView reloadData];
            [self hideHud];
        }else{
            [self showHint:@"加载失败!!"];
            [self hideHud];
        }
        [self.allActivityTableView.mj_header endRefreshing];
        [self.allActivityTableView.mj_footer endRefreshing];
        [self hideHud];
    } errorBlock:^(NSError *enginerError) {
        [self showHint:@"加载出错!!"];
        [self hideHud];
        [self.allActivityTableView.mj_header endRefreshing];
        [self.allActivityTableView.mj_footer endRefreshing];

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
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}
@end
