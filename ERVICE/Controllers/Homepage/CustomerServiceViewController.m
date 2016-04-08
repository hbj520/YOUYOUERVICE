//
//  CustomerServiceViewController.m
//  ERVICE
//
//  Created by youyou on 16/4/7.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "CustomerServiceViewController.h"

#import "CustomerServiceTableViewCell.h"

static NSString *cellReuseId = @"cellReuseId";
@interface CustomerServiceViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;// 数据源
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation CustomerServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //下载数据
    [self loadDataWithPage:0];
    
    //registerTableviewcell
    [self registerTableViewcell];
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
- (void)registerTableViewcell{
    [self.tableView registerClass:[CustomerServiceTableViewCell class] forCellReuseIdentifier:cellReuseId];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}
- (void)loadDataWithPage:(NSInteger)page{
    NSString *nowPage = [NSString stringWithFormat:@"%ld",page];
    [[MyAPI sharedAPI] customerServiceListWithPage:nowPage result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            dataSource = arrays;
            [self.tableView reloadData];
        }
    } errorResult:^(NSError *enginerError) {
        
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
@end
