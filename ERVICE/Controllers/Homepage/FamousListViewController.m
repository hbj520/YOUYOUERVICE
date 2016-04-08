//
//  FamousListViewController.m
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "FamousListViewController.h"

#import "HorizontalTableViewCell.h"
#import "FamousListTableViewCell.h"

static NSString *reuseId1 = @"reuseId1";
static NSString *reuseId2 = @"reuseId2";
@interface FamousListViewController ()<
                                       UITableViewDelegate,
                                       UITableViewDataSource,
                                       HorizontalTableViewCellDelegate>
{
    NSMutableArray *topThreeDataSource;
    NSMutableArray *topListDataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation FamousListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    //下载数据前几名
    [self loadData];
    //下载前几页
    [self loadDataWithPage:0];
    //configTableview
    [self configTableView];
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
        
        FamousTechListModel *model = [topListDataSource objectAtIndex:indexPath.row];
        [cell configWithData:model];
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - PrivateMethod
- (void)loadData{
    //下载排名前几名老师
    [[MyAPI sharedAPI] famousTopThreeWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            topThreeDataSource = arrays;
            [self.tableView reloadData];
        }
    } errorResult:^(NSError *enginerError) {
        
    }];
   
}
- (void)loadDataWithPage:(NSInteger)page{
    NSString *pageNum = [NSString stringWithFormat:@"%ld",page];
    //下载名师列表
    [[MyAPI sharedAPI] famousListWithPage:pageNum result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            topListDataSource = arrays;
            [self.tableView reloadData];
        }
        
    } errorResult:^(NSError *enginerError) {
        
    }];
}
- (void)configTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[HorizontalTableViewCell class] forCellReuseIdentifier:reuseId1];
    [self.tableView registerClass:[FamousListTableViewCell class] forCellReuseIdentifier:reuseId2];
    
    
}
#pragma mark -HorizontalTableViewDelegate
- (void)TapColletionViewCellDelegate:(FamousTechListModel *)famousListModel indexPath:(NSIndexPath *)indexPath{
    
}
- (void)TapCollectionViewCellAttentionBtnDelegate:(UIButton *)attentionBtn indexPath:(NSIndexPath *)indexPath{
    
}

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
