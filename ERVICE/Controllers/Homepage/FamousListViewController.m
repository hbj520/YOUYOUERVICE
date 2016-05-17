//
//  FamousListViewController.m
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "FamousListViewController.h"
#import "TeacherAnlyzeViewController.h"

#import <MJRefresh/MJRefresh.h>

#import "HorizontalTableViewCell.h"
#import "FamousListTableViewCell.h"

#import "FamousTechListModel.h"

static NSString *reuseId1 = @"reuseId1";
static NSString *reuseId2 = @"reuseId2";
@interface FamousListViewController ()<
                                       UITableViewDelegate,
                                       UITableViewDataSource,
                                       HorizontalTableViewCellDelegate,
                                       UIAlertViewDelegate>
{
    NSMutableArray *topThreeDataSource;
    NSMutableArray *topListDataSource;
    NSInteger _page;
    //判断是否在加载
    BOOL isLoding;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation FamousListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    self.tableView.showsVerticalScrollIndicator = NO;
    _page = 1;
    //下载数据前几名
    [self loadData];
    //下载前几页
    [self loadDataWithPage:1];
    //configTableview
    [self configTableView];
    //添加刷新和下拉加载更多
    [self addRefresh];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return topListDataSource.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HorizontalTableViewCell *horCell = [[HorizontalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId1];
        horCell.delegate = self;
        horCell.selectionStyle = UITableViewCellSelectionStyleNone;
        horCell.modelsArray = topThreeDataSource;
        return horCell;
    }else if (indexPath.section == 1){

        FamousListTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"FamousListTableViewCell" owner:self options:nil] lastObject];
        if (topListDataSource.count == 0) {
            return cell;
        }
        FamousTechListModel *model = [topListDataSource objectAtIndex:indexPath.row];
        [cell configWithData:model];
        __weak FamousListViewController *weakself = self;
        cell.tapBlock = ^(UIButton *btn){
            
            //点击关注
            if (!btn.isSelected) {
                
                [weakself showHudInView:self.view hint:@"关注中..."];
                [[MyAPI sharedAPI] attentionTapWithLecturerId:model.techId
                                                       result:^(BOOL sucess, NSString *msg) {
                                                           if (sucess) {
                                                               [btn setImage:[UIImage imageNamed:@"notattention"] forState:UIControlStateNormal];
                                                               btn.selected = YES;
                                                               [self hideHud];
                                                               [self showHint:@"关注成功"];
                                                           }else{
                                                               [self hideHud];
                                                               [self showHint:msg];
                                                           }
                                                       } errorResult:^(NSError *enginerError) {
                                                           [self hideHud];
                                                           [self showHint:@"关注出错!!!"];
                                                       }];
            }else{//取消关注
                [weakself showHudInView:self.view hint:@"取消关注中..."];
                [[MyAPI sharedAPI] noAttentionWithLecturerId:model.techId result:^(BOOL sucess, NSString *msg) {
                    if (sucess) {
                        [btn setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
                        btn.selected = NO;
                        [self hideHud];
                        [self showHint:@"取消关注成功!!!"];
                    }
                } errorResult:^(NSError *enginerError) {
                    [self hideHud];
                    [self showHint:@"取消关注出错!!!"];
                }];
            }
        };
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 170;
    }else{
        return 80;
    }
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    FamousTechListModel *model = [topListDataSource objectAtIndex:indexPath.row];
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Annalyze" bundle:nil];
    TeacherAnlyzeViewController *teacherDetailVC = (TeacherAnlyzeViewController *)[storybord instantiateViewControllerWithIdentifier:@"TeacherDetailStorybordId"];
    teacherDetailVC.teacherId = model.techId;
    teacherDetailVC.teacherName = model.techName;
    [self.navigationController pushViewController:teacherDetailVC animated:YES];
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
   __weak  FamousListViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (topListDataSource.count > 0) {
            [topListDataSource removeAllObjects];
        }
        _page = 1;
        [weakself loadData];
        [weakself loadDataWithPage:1];
    }];
    MJRefreshAutoNormalFooter *footerRefreh = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        NSLog(@"%ld",_page);
        isLoding = YES;
        [weakself loadDataWithPage:_page];
    }];
    footerRefreh.automaticallyRefresh = NO;
    self.tableView.mj_footer = footerRefreh;
    
}
- (void)loadData{
    //下载排名前几名老师
    [[MyAPI sharedAPI] famousTopThreeWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            topThreeDataSource = arrays;
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    } errorResult:^(NSError *enginerError) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
    }];
   
}
- (void)loadDataWithPage:(NSInteger)page{
    NSString *pageNum = [NSString stringWithFormat:@"%ld",page];
    [self showHudInView:self.view hint:@"加载中..."];
    //下载名师列表
    [[MyAPI sharedAPI] famousListWithPage:pageNum result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (success) {
            [topListDataSource addObjectsFromArray:arrays];
            [self.tableView reloadData];
        }
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
        
    } errorResult:^(NSError *enginerError) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        [self hideHud];
    }];
}
- (void)configTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    if (topListDataSource.count > 0) {
        [topListDataSource removeAllObjects];
    }
    topListDataSource = [NSMutableArray array];
    [self.tableView registerClass:[HorizontalTableViewCell class] forCellReuseIdentifier:reuseId1];
    [self.tableView registerClass:[FamousListTableViewCell class] forCellReuseIdentifier:reuseId2];
    
    
}
#pragma mark -HorizontalTableViewDelegate
- (void)TapColletionViewCellDelegate:(FamousTechListModel *)famousListModel indexPath:(NSIndexPath *)indexPath{
    FamousTechListModel *model = [topListDataSource objectAtIndex:indexPath.row];
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Annalyze" bundle:nil];
    TeacherAnlyzeViewController *teacherDetailVC = (TeacherAnlyzeViewController *)[storybord instantiateViewControllerWithIdentifier:@"TeacherDetailStorybordId"];
    teacherDetailVC.teacherId = model.techId;
    teacherDetailVC.teacherName = model.techName;
    [self.navigationController pushViewController:teacherDetailVC animated:YES];
}
- (void)TapCollectionViewCellAttentionBtnDelegate:(UIButton *)attentionBtn indexPath:(NSIndexPath *)indexPath{
    FamousTechListModel *model = [topListDataSource objectAtIndex:indexPath.row];
    //点击关注
    if (!attentionBtn.isSelected) {
        
        [self showHudInView:self.view hint:@"关注中..."];
        [[MyAPI sharedAPI] attentionTapWithLecturerId:model.techId
                                               result:^(BOOL sucess, NSString *msg) {
                                                   if (sucess) {
                                                       [attentionBtn setImage:[UIImage imageNamed:@"notattention"] forState:UIControlStateNormal];
                                                       attentionBtn.selected = YES;
                                                       [self hideHud];
                                                       [self showHint:@"关注成功"];
                                                   }else{
                                                       [self hideHud];
                                                       [self showHint:msg];
                                                   }
                                               } errorResult:^(NSError *enginerError) {
                                                   [self hideHud];
                                                   [self showHint:@"关注出错!!!"];
                                               }];
    }else{//取消关注
        [self showHudInView:self.view hint:@"取消关注中..."];
        [[MyAPI sharedAPI] noAttentionWithLecturerId:model.techId result:^(BOOL sucess, NSString *msg) {
            if (sucess) {
                [attentionBtn setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
                attentionBtn.selected = NO;
                [self hideHud];
                [self showHint:@"取消关注成功!!!"];
            }
        } errorResult:^(NSError *enginerError) {
            [self hideHud];
            [self showHint:@"取消关注出错!!!"];
        }];
    }
}

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - UIAlertViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [Tools hideKeyBoard];

}
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}

@end
