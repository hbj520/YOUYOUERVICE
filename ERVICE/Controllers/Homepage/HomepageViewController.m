//
//  HomepageViewController.m
//  ERVICE
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "HomepageViewController.h"
#import "AttentionTeacherListViewController.h"
#import "FamousListViewController.h"


#import "SDCycleScrollView.h"
#import "HomepageHeaderTableViewCell.h"
#import "HomepageActivityTableViewCell.h"
#import "HomepageAnalyzeTableViewCell.h"
#import "ThreeTableViewCell.h"
#import "TeacherAnnalyzeTableViewCell.h"
#import "Tools.h"
#import "Marco.h"
#import "FinanceAnnalyzeViewController.h"
#import "AppDelegate.h"
#import <MJRefresh/MJRefresh.h>

#import "HomepageBannerModel.h"
#import "HomepageExchangeModel.h"

#import "AttentionViewController.h"
@interface HomepageViewController ()<UITableViewDataSource,
                                     UITableViewDelegate,
                                     SDCycleScrollViewDelegate,
                                     HomepageTabelViewCellDelegate>
{
    SDCycleScrollView *_headerView;
    NSMutableArray *bannerData;//滚动视图数据
    NSMutableArray *exchangeData;//交易所数据
    NSInteger _collectionLines;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //下载数据
    [self loadData];
    //设置navtitle
    [self setNavTitle];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //添加刷新
    [self addRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - privateMethod
- (void)addRefresh{
    __weak  HomepageViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
    }];
}
- (void)loadData{
    [self showHudInView:self.view hint:@"加载中..."];
    [[MyAPI sharedAPI] getHomepageDataWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            
            bannerData = arrays[0];
            exchangeData = arrays[1];
            _collectionLines = [Tools simulateLinesWithArray:exchangeData.count
withList:3];
            //头部滚动视图
            [self configPageViews];
            [self congfigTableView];
            [self.tableView reloadData];
            [self hideHud];
        }else{
            [self hideHud];
        }
        [self.tableView.mj_header endRefreshing];
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"下载出错"];
        [self hideHud];
        [self.tableView.mj_header endRefreshing];

    }];
}
- (void)configPageViews{
    NSMutableArray *imagArray = [NSMutableArray array];
    for (HomepageBannerModel *model in bannerData) {
        [imagArray addObject:model.imageUrl];
    }
    _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,ScreenWidth,160) imageURLStringsGroup:imagArray];
    _headerView.delegate = self;
    
    
}
- (void)congfigTableView{
    [self.tableView registerClass:[HomepageHeaderTableViewCell class] forCellReuseIdentifier:@"homepageReusedId1"];
    [self.tableView registerClass:[HomepageActivityTableViewCell class] forCellReuseIdentifier:@"homepageReused2"];
    [self.tableView registerClass:[HomepageAnalyzeTableViewCell class] forCellReuseIdentifier:@"homepageReused3"];
    [self.tableView registerClass:[ThreeTableViewCell class] forCellReuseIdentifier:@"homepageReused4"];
    //[self.tableView registerClass:[TeacherAnnalyzeTableViewCell class] forCellReuseIdentifier:@"homepageReused4"];
    
}
- (void)setNavTitle{
    NSString *navTitle = @"V家金服";
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,[UIColor darkGrayColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationItem.title = navTitle;
    
}
//点击我的专属
- (void)clickMyExculsive{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    AttentionTeacherListViewController *teacherListVC = (AttentionTeacherListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"attentionTeachListId"];
    [self.navigationController pushViewController:teacherListVC animated:YES];
}
//点击业务咨询
- (void)clickBusiness{
    
}
//点击专家会诊
- (void)clickSpecail{
    
}
//点击名人榜单
- (void)clickFamous{
    [self performSegueWithIdentifier:@"FamousListSegue" sender:nil];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HomepageHeaderTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HomepageHeaderTableViewCell" owner:self options:nil]lastObject];
        //我的专属，业务咨询，名人榜单，专家会诊
        __weak HomepageViewController *weakself = self;
        cell.myExculsiveBlock = ^(){
            [weakself clickMyExculsive];
        };
        cell.businessBlock = ^(){
            [weakself clickBusiness];
        };
        cell.specialistBlock = ^(){
            [weakself clickSpecail];
        };
        cell.famousBolck = ^(){
            [weakself clickFamous];
        };
        return cell;
    }else if (indexPath.section == 1){
        HomepageActivityTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HomepageActivityTableViewCell" owner:self options:nil] lastObject];
        return cell;
        
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            HomepageAnalyzeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HomepageAnalyzeTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
           ThreeTableViewCell *cell = [[ThreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homepageReused4"];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.modelsArray = exchangeData;
            return cell;
        }
        
        
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 200.;
    }else if (section == 1){
        return 2.;
    }else{
        return 20.;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100.;
    }else if (indexPath.section == 1){
        return 38.;
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            return 38.;
        }else{
            return 150;
        }
    }
    return 46;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0) {
        //点击进入分析页面
//        [self performSegueWithIdentifier:@"financeSegue" sender:nil];
        self.tabBarController.selectedIndex = 1;
    }
}
#pragma mark -SDCycleScrollViewDelegate
//点击头部滚动视图
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
}
#pragma mark - TapCollectionCellDelegate
- (void)TapCollectionViewCellDelegate:(HomepageAnalyzeModel *)analyzeModel tapIndexPath:(NSIndexPath *)indexPath{
    HomepageExchangeModel *exModel = exchangeData[indexPath.row];
    
    AttentionViewController *viewController = [ApplicationDelegate.annalyzeStorybord instantiateViewControllerWithIdentifier:@"CompanyAnnalyzeId"];
    viewController.exid = exModel.exchangeId;
    viewController.exName = exModel.exchangName;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - SegueDelegate

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"financeSegue"]) {
        FinanceAnnalyzeViewController *financeVC = (FinanceAnnalyzeViewController *)segue.destinationViewController;
        
    }
}


@end
