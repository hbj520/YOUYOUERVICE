//
//  AnnounceViewController.m
//  ERVICE
//
//  Created by apple on 3/24/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "AnnounceViewController.h"
#import "AnnouncementDetaiViewController.h"

#import "ActivityHeaderTableViewCell.h"
#import "TeacherAnnalyzeTableViewCell.h"
#import "AnnalyzeTitleTableViewCell.h"
#import "AnnounceContentTableViewCell.h"
#import "AnnounceTitleView.h"
#import "SDCycleScrollView.h"
#import <MJRefresh/MJRefresh.h>

#import "AnnounceExchangeModel.h"
#import "HomepageBannerModel.h"
#import "AnnoucementModel.h"

static NSString *announceHeaderReuseId = @"announceHeaderReuseId";
static NSString *announceScrollReuseId = @"announceScrollReuseId";
static NSString *announceTitleReuseId = @"announceTitleReuseId";
static NSString *announceContentId = @"announceContentId";
@interface AnnounceViewController ()<UITableViewDelegate,UITableViewDataSource,SDCycleScrollViewDelegate,UIAlertViewDelegate>
{
    SDCycleScrollView *_headerView;
    NSMutableArray *bannerDataSource;//滚动视图数据源
    NSMutableArray *exchangeDataSource;// 交易所数据源
    NSMutableArray *articleDataSource;// 文章数据
    NSInteger _page;//页数
    NSInteger nowExchangeIndex;//现在选中的交易所索引
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AnnounceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //下载数据
    _page = 1;
    nowExchangeIndex = 0;
    [self loadData];
    [self setupTableView];
    [self setNavTitle];
    
    //添加刷新
    [self addRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PrivateMethod
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)addRefresh{
    __weak  AnnounceViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        if (articleDataSource) {
            [articleDataSource removeAllObjects];
        }
        [weakself loadData];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        AnnounceExchangeModel *model = exchangeDataSource[nowExchangeIndex];
        [weakself loadListDataWithPage:_page withExchangeId:model.exchangeId];
    }];
}
- (NSMutableArray *)configlImagesAndTitlesWitAnnalyArray:(NSArray *)array{
    NSMutableArray *data = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *titleArray = [NSMutableArray array];
    for ( AnnounceExchangeModel *categoryModel in array) {
        [imageArray addObject:categoryModel.exchangeImageurl];
        [titleArray addObject:categoryModel.exchangName];
    }
    [data addObject:imageArray];
    [data addObject:titleArray];
    return data;
    
}
- (void)configPageViews{
    NSMutableArray *imagArray = [NSMutableArray array];
    for (HomepageBannerModel *model in bannerDataSource) {
        [imagArray addObject:model.imageUrl];
    }
    _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,ScreenWidth,160) imageURLStringsGroup:imagArray];
    _headerView.delegate = self;
    
    
}
- (void)loadData{
    // 下载滚动视图
   [[MyAPI sharedAPI] AnnouncementBannerWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
       //登录超时处理
       if ([msg isEqualToString:@"登录超时"]) {
           [self timeOutAction];
       }
       if (success) {
           bannerDataSource = arrays;
           [self configPageViews];
           [self.tableView reloadData];
           
       }else{
           
           NSLog(@"下载失败");
       }
       
   } errorResult:^(NSError *enginerError) {
       
       
   }];
    //下载交易所
    [[MyAPI sharedAPI] AnnouncementExchangeWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            exchangeDataSource = arrays;
            AnnounceExchangeModel *model = arrays[0];
            [self loadListDataWithPage:0 withExchangeId:model.exchangeId];
            [self.tableView reloadData];

        }else{
            
        }
        [self.tableView.mj_header endRefreshing];
    } errorResult:^(NSError *enginerError) {
        [self.tableView.mj_header endRefreshing];
    }];
}
//下载文章列表
- (void)loadListDataWithPage:(NSInteger)page withExchangeId:(NSString *)exid{
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *pagestring = [NSString stringWithFormat:@"%ld",page];
   [[MyAPI sharedAPI] AnnounceListWithParamters:exid page:pagestring result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
       if (success) {
           if (!articleDataSource) {
               articleDataSource = [NSMutableArray array];
           }
           [articleDataSource addObjectsFromArray:arrays];
           [self.tableView reloadData];

       }
       [self.tableView.mj_footer endRefreshing];
       [self.tableView.mj_header endRefreshing];
       [self hideHud];
   } errorResult:^(NSError *enginerError) {
       [self.tableView.mj_footer endRefreshing];
       [self.tableView.mj_header endRefreshing];
       [self hideHud];
   }];
}
- (void)setupTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ActivityHeaderTableViewCell class] forCellReuseIdentifier:announceHeaderReuseId];
    [self.tableView registerClass:[TeacherAnnalyzeTableViewCell class] forCellReuseIdentifier:announceScrollReuseId];
    [self.tableView registerClass:[AnnalyzeTitleTableViewCell class] forCellReuseIdentifier:announceTitleReuseId];
    [self.tableView registerClass:[AnnounceContentTableViewCell class] forCellReuseIdentifier:announceContentId];
}
- (void)setNavTitle{
    NSString *navTitle = @"公告";
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,[UIColor darkGrayColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationItem.title = navTitle;
    
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if (section == 2){
        return articleDataSource.count;
    }
    return 1;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _headerView;
    }
    if (section == 2) {
        AnnounceTitleView *headerView = [[[NSBundle mainBundle] loadNibNamed:@"AnnounceTitleView" owner:self options:nil] lastObject];
        if (exchangeDataSource.count > 0) {
            AnnounceExchangeModel *model = [exchangeDataSource objectAtIndex:nowExchangeIndex];
            [headerView configWithData:model];
        }

        return headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 160;
    }
    if (section == 2) {
        return 60;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 1 ) {
        return 10;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ActivityHeaderTableViewCell *headerCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityHeaderTableViewCell" owner:self options:nil] lastObject];
        [headerCell configWithsmallImage:@"activityNew" reminder:@"投资有风险，入市需谨慎"];
        return headerCell;
    }else if (indexPath.section == 1){
        TeacherAnnalyzeTableViewCell *scrollCell = [[[NSBundle mainBundle] loadNibNamed:@"TeacherAnnalyzeTableViewCell" owner:self options:nil] lastObject];
    
          NSMutableArray *category = [self configlImagesAndTitlesWitAnnalyArray:exchangeDataSource];

        [scrollCell configWithNormalImgArr:category[0] showGridArr:category[1] isShowTitles:YES];
        scrollCell.mScrollView.gridClickBlock = ^(CustomGrid *grid){
            nowExchangeIndex = grid.gridIndex;//目前选中的index
            AnnounceExchangeModel *exchangeModel = [exchangeDataSource objectAtIndex:grid.gridIndex];
            _page = 1;
            if (articleDataSource) {
                [articleDataSource removeAllObjects];
            }
            [self loadListDataWithPage:_page withExchangeId:exchangeModel.exchangeId];
        };
        return scrollCell;
    }else if (indexPath.section  == 2){
        AnnoucementModel *model = [articleDataSource objectAtIndex:indexPath.row];
        AnnounceContentTableViewCell *announceContentCell = [[[NSBundle mainBundle] loadNibNamed:@"AnnounceContentTableViewCell" owner:self options:nil] lastObject];
        [announceContentCell configWithData:model];
        return announceContentCell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 35;
    }else if (indexPath.section == 1){
        return 100;
    }else if (indexPath.section == 2){
        return 46;
    }
    return -1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    AnnoucementModel *model = [articleDataSource objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"AnnounceArticleSegue" sender:model.articelId];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    AnnouncementDetaiViewController *announceDetailVC = (AnnouncementDetaiViewController *)segue.destinationViewController;
    announceDetailVC.articleId = (NSString *)sender;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
