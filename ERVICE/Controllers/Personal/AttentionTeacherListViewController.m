//
//  AttentionTeacherListViewController.m
//  ERVICE
//
//  Created by 陈 志徽 on 16/4/5.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "AttentionTeacherListViewController.h"

#import "MyTeacherModel.h"

#import "AttentionListTableViewCell.h"

static NSString *reuserId = @"attentionListId";
@interface AttentionTeacherListViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtn:(UIBarButtonItem *)sender;


@end

@implementation AttentionTeacherListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    //下载数据
    [self loadData];
    
    //注册tableviewcell
    [self registerTableViewCell];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark - PrivateMethod
- (void)registerTableViewCell{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[AttentionListTableViewCell class] forCellReuseIdentifier:reuserId];
}
- (void)loadData{
    [[MyAPI sharedAPI] myTeacherWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        
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
    [self performSegueWithIdentifier:@"AttentionTeacherSegue" sender:nil];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
