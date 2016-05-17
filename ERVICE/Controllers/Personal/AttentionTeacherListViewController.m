//
//  AttentionTeacherListViewController.m
//  ERVICE
//
//  Created by 陈 志徽 on 16/4/5.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "AttentionTeacherListViewController.h"
#import "AttentionTeacherTableViewController.h"
#import "ChatViewController.h"


#import <MJRefresh/MJRefresh.h>
#import "MyTeacherModel.h"

#import "AttentionListTableViewCell.h"

static NSString *reuserId = @"attentionListId";
@interface AttentionTeacherListViewController ()<
UITableViewDelegate,
UITableViewDataSource,
UIAlertViewDelegate>
{
    NSMutableArray *dataSource;
    NSInteger _page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtn:(UIBarButtonItem *)sender;


@end

@implementation AttentionTeacherListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    if (self.isSpecail) {
        [self addRefresh];
        _page = 1;
        [self loadDataWithPage:_page];
    }else{
        //下载数据
        [self loadData];
    }
    //注册tableviewcell
    [self registerTableViewCell];
    //注册通知
    [self noattentionSuccessNotice];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark - PrivateMethod
- (void)addRefresh{
    __weak  AttentionTeacherListViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (dataSource.count > 0) {
            [dataSource removeAllObjects];
        }
        _page = 1;
        [weakself loadDataWithPage:1];
    }];
    MJRefreshAutoNormalFooter *footerRefreh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        NSLog(@"%ld",_page);
        [weakself loadDataWithPage:_page];
    }];
    footerRefreh.automaticallyRefresh = NO;
    self.tableView.mj_footer = footerRefreh;
    
}
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)noattentionSuccessNotice{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noAttetionAct:) name:@"noattentionsuccess" object:nil];
}
- (void)noAttetionAct:(id)sender{
    [self loadData];
}
- (void)registerTableViewCell{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AttentionListTableViewCell class] forCellReuseIdentifier:reuserId];
}
- (void)loadDataWithPage:(NSInteger)page{
    [self showHudInView:self.view hint:@"加载..."];
    NSString *nowPage = [NSString stringWithFormat:@"%ld",page];
    [[MyAPI sharedAPI] SpecailListWithPage:nowPage result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
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
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [self hideHud];
        }else{
            [self.tableView.mj_footer endRefreshing];
            [self.tableView.mj_header endRefreshing];
            [self showHint:@"下载失败"];
            [self hideHud];
        }
    } errorResult:^(NSError *enginerError) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self showHint:@"下载出错"];
        [self hideHud];
    }];
    
}
- (void)loadData{
    if (dataSource.count > 0) {
        [dataSource removeAllObjects];
    }
    [[MyAPI sharedAPI] myTeacherWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (success) {
            dataSource = arrays;
            [self.tableView reloadData];
        }else{
            
        }
        
    } errorResult:^(NSError *enginerError) {
        
    }];
}
#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AttentionListTableViewCell *cell ;
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AttentionListTableViewCell" owner:self options:nil] lastObject];
    MyTeacherModel *model = [dataSource objectAtIndex:indexPath.row];
    [cell configWithData:model];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 99.;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
     MyTeacherModel *model = [dataSource objectAtIndex:indexPath.row];
    if (self.isSpecail) {
        ChatViewController *chatController = [[ChatViewController alloc] initWithConversationChatter:model.techId conversationType:EMConversationTypeChat];
        [self.navigationController pushViewController:chatController animated:YES];
    }else{
        [self performSegueWithIdentifier:@"AttentionTeacherSegue" sender:model];
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    MyTeacherModel *model = (MyTeacherModel *)sender;
    AttentionTeacherTableViewController *myTeacherVC = segue.destinationViewController;
    myTeacherVC.myTech = model;
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
