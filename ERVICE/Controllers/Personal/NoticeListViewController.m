//
//  NoticeListViewController.m
//  ERVICE
//
//  Created by youyou on 16/4/12.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "NoticeListViewController.h"
#import "NoticeWebViewController.h"

#import "NoticeListTableViewCell.h"

#import "NoticeModel.h"

#import <MJRefresh/MJRefresh.h>
static NSString *reuserId = @"NoticeListTableViewCellId";
@interface NoticeListViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSInteger _page;
    NSMutableArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation NoticeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self createUI];
    [self addRefresh];
    _page = 1;
    [self loadDataWithPage:_page];
    // Do any additional setup after loading the view.
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
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)addRefresh{
    __weak NoticeListViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _page = 1;
        if (dataSource.count > 0) {
            [dataSource removeAllObjects];
        }
        [weakself loadDataWithPage:_page];
        
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakself loadDataWithPage:_page];
    }];
}
- (void)createUI{
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticeListTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:reuserId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}
- (void)loadDataWithPage:(NSInteger)page{
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *nowPage = [NSString stringWithFormat:@"%ld",page];
    [[MyAPI sharedAPI] noticeListWithPage:nowPage result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (success) {
            if (!dataSource) {
                dataSource = [NSMutableArray array];
            }
            [dataSource addObjectsFromArray:arrays];
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self hideHud];
        
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"加载出错"];
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self hideHud];
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NoticeListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId forIndexPath:indexPath];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeListTableViewCell" owner:self options:nil] lastObject];
    }
    NoticeModel *model = [dataSource objectAtIndex:indexPath.row];
    [cell configWithData:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 75;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    NoticeModel *model = [dataSource objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"noticeDetailSegue" sender:model.noticeId];
}
- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    NoticeWebViewController *noticeVC = (NoticeWebViewController *)segue.destinationViewController;
    NSString *noticeId = (NSString *)sender;
    noticeVC.noticeId = noticeId;
}
@end
