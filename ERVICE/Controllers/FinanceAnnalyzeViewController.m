//
//  FinanceAnnalyzeViewController.m
//  ERVICE
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "FinanceAnnalyzeViewController.h"
#import "AttentionViewController.h"

#import "FinanceAnnalyzeTableViewCell.h"
#import "Marco.h"
#import "SelectImageView.h"
#import "SDCycleScrollView.h"
#import <MJRefresh/MJRefresh.h>


#import "HomepageBannerModel.h"
#import "FinanceModel.h"
#import "FinanceItemModel.h"

#import <SDWebImage/UIImageView+WebCache.h>
@interface FinanceAnnalyzeViewController ()<
                         UITableViewDataSource,
                         UITableViewDelegate>
{
    NSMutableArray *dataSource;
    SDCycleScrollView *_headerView;
    FinanceModel *financeDataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FinanceAnnalyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setNavTitle];
    //下载数据
    [self loadData];
        //添加刷新
    [self addRefresh];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[FinanceAnnalyzeTableViewCell class] forCellReuseIdentifier:@"FinanceAnnalyzeId"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return financeDataSource.exchanges.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FinanceItemModel *finaItem = [financeDataSource.exchanges objectAtIndex:indexPath.row];
    FinanceAnnalyzeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FinanceAnnalyzeTableViewCell" owner:self options:nil] lastObject];
    [cell configWithData:finaItem];

    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 115;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    FinanceItemModel *model = [financeDataSource.exchanges objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"attentionSegue" sender:model];
    
}
#pragma mark - PrivateMethod
- (void)addRefresh{
    __weak  FinanceAnnalyzeViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
}
- (void)configPageViews{
    NSMutableArray *imagArray = [NSMutableArray array];
    for (HomepageBannerModel *model in financeDataSource.banners) {
        [imagArray addObject:model.imageUrl];
    }
    _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,ScreenWidth,160) imageURLStringsGroup:imagArray];
    _headerView.delegate = self;
    
}
- (void)loadData{
    [[MyAPI sharedAPI] FinanceAnnalyzeListResult:^(BOOL success, NSString *msg, id object) {
        if (success) {
            financeDataSource = (FinanceModel *)object;
            [self configPageViews];
            [self.tableView reloadData];
        }else {
            
        }
        [self.tableView.mj_header endRefreshing];
    } errorResult:^(NSError *enginerError) {
        
         [self.tableView.mj_header endRefreshing];
    }];
}
- (void)setNavTitle{
    NSString *navTitle = @"财经分析";
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,[UIColor darkGrayColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationItem.title = navTitle;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    FinanceItemModel *model = (FinanceItemModel *)sender;
    AttentionViewController *attentionVC = (AttentionViewController *)segue.destinationViewController;
    attentionVC.exid = model.exid;
    attentionVC.exName = model.exname;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma mark -SDCycleScrollViewDelegate
//点击头部滚动视图
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
@end
