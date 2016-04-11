//
//  CustomerServiceViewController.m
//  ERVICE
//
//  Created by youyou on 16/4/7.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "CustomerServiceViewController.h"

#import "CustomerServiceTableViewCell.h"

#import <MJRefresh/MJRefresh.h>

static NSString *cellReuseId = @"cellReuseId";
@interface CustomerServiceViewController ()<UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *dataSource;// 数据源
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation CustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _page = 1;
    //下载数据
    [self loadDataWithPage:1];
    
    //registerTableviewcell
    [self registerTableViewcell];
    
    //添加刷新和下拉加载更多
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
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)addRefresh{
    __weak  CustomerServiceViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (dataSource.count > 0) {
            [dataSource removeAllObjects];
        }
        _page = 1;
        [weakself loadDataWithPage:1];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        ++_page;
        [weakself loadDataWithPage:_page];
    }];
}
- (void)registerTableViewcell{
    [self.tableView registerClass:[CustomerServiceTableViewCell class] forCellReuseIdentifier:cellReuseId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}
- (void)loadDataWithPage:(NSInteger)page{
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *nowPage = [NSString stringWithFormat:@"%ld",page];
    [[MyAPI sharedAPI] customerServiceListWithPage:nowPage result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
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
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } errorResult:^(NSError *enginerError) {
        [self hideHud];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CustomerServiceTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"CustomerServiceTableViewCell" owner:self options:nil] lastObject];
    CustomerServiceModel *model = [dataSource objectAtIndex:indexPath.row];
    [cell configWithData:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
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
@end
