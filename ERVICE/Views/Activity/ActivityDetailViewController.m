//
//  ActivityDetailViewController.m
//  ERVICE
//
//  Created by apple on 3/23/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "ActivityApplyViewController.h"

#import "ActivityDetailHeaderTableViewCell.h"
#import "ActivityDetailSmailTableViewCell.h"
#import "ActivityWebViewTableViewCell.h"
#import "Hexcolor.h"
#import "Marco.h"

#import "ActivityDetailModel.h"

static NSString *detailHeaderId = @"detailHeaderReuseId";
static NSString *detailSmailHeaderId = @"detialSmaillHeaderId";
static NSString *detailWebViewId = @"detailWebViewId";
@interface ActivityDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIButton *apartBtn;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) ActivityDetailModel *activityDataSourece;
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //下载数据
    [self loadData];
    [self setupTableView];
    [self creatApartBtn];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        ActivityDetailHeaderTableViewCell *headercell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityDetailHeaderTableViewCell" owner:self options:nil] lastObject];
        [headercell configWithData:self.activityDataSourece];
        return headercell;
    }else if (indexPath.section == 1){
        ActivityDetailSmailTableViewCell *smallCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityDetailSmailTableViewCell" owner:self options:nil] lastObject];
        return smallCell;
    }else if (indexPath.section == 2){
        ActivityWebViewTableViewCell *webCell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityWebViewTableViewCell" owner:self options:nil] lastObject];
        [webCell configWithId:self.activityId];
        return webCell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else if (section == 1){
        return 2;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 245;
    }else if (indexPath.section == 1){
        return 46;
    }else if (indexPath.section == 2
              ){
        return 300;
    }
    return 10;
}
#pragma mark - PrivateMethod
- (void)setupTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ActivityDetailHeaderTableViewCell class] forCellReuseIdentifier:detailHeaderId];
    [self.tableView registerClass:[ActivityDetailSmailTableViewCell class] forCellReuseIdentifier:detailSmailHeaderId];
    [self.tableView registerClass:[ActivityWebViewTableViewCell class] forCellReuseIdentifier:detailWebViewId];
}
- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - PrivateMethod
- (void)loadData{
    [self showHudInView:self.view hint:@"加载数据中..."];
    [[MyAPI sharedAPI] loadActivityDetailWithActivityId:self.activityId result:^(BOOL success, NSString *msg, id object) {
        if (success) {
            self.activityDataSourece = (ActivityDetailModel *)object;
            [self.tableView reloadData];
            [self showHint:@"加载完成！！"];
            [self hideHud];
        }else{
            [self showHint:@"加载失败！！"];
            [self hideHud];
        }
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"加载出错！！"];
        [self hideHud];
    }];
}
- (void)creatApartBtn{
//    self.tabBarController.tabBar.hidden = YES;
//    self.tabBarController.tabBar.alpha = 0;
    apartBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [apartBtn setTitle:@"我要参加活动" forState:UIControlStateNormal];
    //    apartBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 64)];
    [apartBtn setBackgroundColor:[UIColor colorWithHexString:@"ff5000"]];
    apartBtn.tintColor = [UIColor whiteColor];
    apartBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    apartBtn.frame = CGRectMake(0, ScreenHeight-128, ScreenWidth, 64);
    [apartBtn addTarget:self action:@selector(aprtAct:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:apartBtn];
    [self.view bringSubviewToFront:apartBtn];
}
- (void)aprtAct:(id)sender{
    [self showHudInView:self.view hint:@"报名参加..."];
    [[MyAPI sharedAPI] apartActivityWithActivityId:self.activityId result:^(BOOL sucess, NSString *msg) {
        if (sucess) {
            [self showHint:@"报名成功！！"];
            [self hideHud];
        }else{
            [self showHint:@"报名失败!!"];
            [self hideHud];
        }
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"报名出错!!"];
        [self hideHud];
    }];
}
#pragma mark - PrepareformSegue
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
//    ActivityApplyViewController *applyVC = (ActivityApplyViewController *)segue.destinationViewController;
//    applyVC.activityId = (NSString *)sender;
//}
@end
