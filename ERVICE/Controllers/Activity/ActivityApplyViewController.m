//
//  ActivityApplyViewController.m
//  ERVICE
//
//  Created by apple on 3/23/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "ActivityApplyViewController.h"
#import "ApplyExitTableViewCell.h"
#import "ApplyNameTableViewCell.h"
#import "ApplyPhoneTableViewCell.h"
#import "ApplyCodeTableViewCell.h"
#import "ApplyActivityBtnTableViewCell.h"
static NSString *reuseApplyExitId = @"reuseApplyExitId";
static NSString *reuseApplyNameId = @"reuseApplyNameId";
static NSString *reuseApplyPhoneId = @"reuseApplyPhoneId";
static NSString *reuseApplyCodeId = @"reuseApplyCodeId";
static NSString *reuserApplyBtnId = @"reuseApplyBtnId";
@interface ActivityApplyViewController ()<UITableViewDataSource,UITabBarDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ActivityApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    [self setupTableView];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
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
- (void)setupTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ApplyExitTableViewCell class] forCellReuseIdentifier:reuseApplyExitId];
    [self.tableView registerClass:[ApplyNameTableViewCell class] forCellReuseIdentifier:reuseApplyNameId];
    [self.tableView registerClass:[ApplyPhoneTableViewCell class] forCellReuseIdentifier:reuseApplyPhoneId];
    [self.tableView registerClass:[ApplyCodeTableViewCell class] forCellReuseIdentifier:reuseApplyCodeId];
    [self.tableView registerClass:[ApplyActivityBtnTableViewCell class] forCellReuseIdentifier:reuserApplyBtnId];
}
- (void)exitAct:(id)sender{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 2;
    }else {
        return 1;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            ApplyExitTableViewCell *exitCell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyExitTableViewCell" owner:self options:nil] lastObject];
            UIButton *exitBtn = [exitCell viewWithTag:10];
            [exitBtn addTarget:self action:@selector(exitAct:) forControlEvents:UIControlEventTouchUpInside];
            return exitCell;
        }else if(indexPath.row == 1){
            ApplyNameTableViewCell *nammeCell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyNameTableViewCell" owner:self options:nil] lastObject];
            return nammeCell;
        }
    }else if (indexPath.section == 1){
        ApplyPhoneTableViewCell *phoneCell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyPhoneTableViewCell" owner:self options:nil] lastObject];
        return phoneCell;
    }else if (indexPath.section == 2){
        ApplyCodeTableViewCell *codeCell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyCodeTableViewCell" owner:self options:nil] lastObject];
        return codeCell;
    }else if (indexPath.section == 3){
        ApplyActivityBtnTableViewCell *btnCell = [[[NSBundle mainBundle] loadNibNamed:@"ApplyActivityBtnTableViewCell" owner:self options:nil] lastObject];
        return btnCell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 3) {
        return 0;
    }
    return 2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return 80;
        }
    }
    return 62;;
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [Tools hideKeyBoard];
}
@end
