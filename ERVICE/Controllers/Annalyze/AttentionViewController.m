//
//  AttentionViewController.m
//  ERVICE
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "AttentionViewController.h"
#import "AttentionTableViewCell.h"
#import "TeacherAnlyzeViewController.h"
#import "LecturerModel.h"
static NSString *reuseId = @"annalyzeId";
@interface AttentionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataSource;//数据源
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation AttentionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //下载数据
    [self loadData];
    [self setNavItem];
    [self configTableView];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PrivateMethod
- (void)setNavItem{
    self.navigationItem.title = self.exName;
    self.navigationItem.hidesBackButton = YES;
}
- (void)configTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AttentionTableViewCell class] forCellReuseIdentifier:reuseId];
}
#pragma mark - TableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataSource.count;;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   AttentionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    cell = [[[NSBundle mainBundle] loadNibNamed:@"AttentionTableViewCell" owner:self options:nil] lastObject];
    LecturerModel *model = [self.dataSource objectAtIndex:indexPath.section];
    [cell configWithData:model];
    __weak AttentionTableViewCell *mCell = cell;
    __weak UIViewController *weakself = self;
    cell.attentionClickBlock = ^(BOOL isAttention){
        //点击关注
        if (!isAttention) {
            
            [weakself showHudInView:self.view hint:@"关注中..."];
            [[MyAPI sharedAPI] attentionTapWithLecturerId:model.userid
                                                   result:^(BOOL sucess, NSString *msg) {
                if (sucess) {
                        [mCell.attentionBtn setImage:[UIImage imageNamed:@"notattention"] forState:UIControlStateNormal];
                    mCell.attentionBtn.selected = YES;
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
          [[MyAPI sharedAPI] noAttentionWithLecturerId:model.userid result:^(BOOL sucess, NSString *msg) {
              if (sucess) {
                  [mCell.attentionBtn setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
                  mCell.attentionBtn.selected = NO;
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
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 142.;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LecturerModel *lecModel = [self.dataSource objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"teacherSegue" sender:lecModel];
}
#pragma mark - PrivateMethod
- (void)loadData{
    [self showHudInView:self.view hint:@"加载中..."];
    [[MyAPI sharedAPI] getLecturerListWithExId:self.exid result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            self.dataSource = arrays;
            [self.tableView reloadData];
            [self hideHud];
        }else{
            [self hideHud];
            [self showHint:@"暂无讲师信息!!"];
        }
    } errorResult:^(NSError *enginerError) {
        [self hideHud];
        [self showHint:@"下载出错！！"];
    }];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TeacherAnlyzeViewController *annalyzeVC = (TeacherAnlyzeViewController *)segue.destinationViewController;
    LecturerModel *lecModel = (LecturerModel *)sender;
    annalyzeVC.teacherId = lecModel.userid;
    annalyzeVC.teacherName = lecModel.username;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
