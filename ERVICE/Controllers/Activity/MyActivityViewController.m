//
//  MyActivityViewController.m
//  ERVICE
//
//  Created by apple on 3/22/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "MyActivityViewController.h"
#import "Hexcolor.h"
#import "MyActivityHeaderTableViewCell.h"
#import "ActivityContentTableViewCell.h"
#import "MoveScrollView.h"

#import <MJRefresh.h>
static NSString *reuseHeaderId = @"myActivityId";
static NSString *reuseContentId = @"myActivityContenId";
@interface MyActivityViewController ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *dataSource;
}
@property (weak, nonatomic) IBOutlet UITableView *myActivityTableView;
@end

@implementation MyActivityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //下载数据
    [self loadDataWithPage:0];
    [self configTableView];
    
    //添加刷新
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
- (void)addRefresh{
    __weak MyActivityViewController *weakself = self;
    self.myActivityTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadDataWithPage:0];
    }];
}
- (void)configTableView{
    self.myActivityTableView.delegate = self;
    self.myActivityTableView.dataSource = self;
    [self.myActivityTableView registerClass:[MyActivityHeaderTableViewCell class] forCellReuseIdentifier:reuseHeaderId];
    [self.myActivityTableView registerClass:[ActivityContentTableViewCell class] forCellReuseIdentifier:reuseContentId];

}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else{
        return dataSource.count;
    }
    return -1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        MyActivityHeaderTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"MyActivityHeaderTableViewCell" owner:self options:nil] lastObject];
        //模拟数据
        NSMutableArray *normalImage = [NSMutableArray arrayWithArray:@[@"silver",@"metal",@"oil",@"stock",@"home_add"]];
        NSMutableArray *showGridArr = [NSMutableArray arrayWithObjects:@"", @"",@"",@"",@"", nil];
        [cell configWithNormalImgArr:normalImage showGridArr:showGridArr isShowTitle:NO];
        cell.mScrollView.showsHorizontalScrollIndicator = NO;
        cell.mScrollView.showsVerticalScrollIndicator = NO;
        cell.mScrollView.gridClickBlock = ^(CustomGrid *grid){
            NSLog(@"点击头部按钮");
        };
        return cell;
    }else if (indexPath.section == 1){
        ActivityContentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"ActivityContentTableViewCell" owner:self options:nil] lastObject];
        return cell;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }else if (indexPath.section == 1){
        return 80;
    }
    return -1;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.selected = NO;
    [self performSegueWithIdentifier:@"MyactivityDetailSegue" sender:nil];
}
#pragma mark - XLSwipeContainerItemDelegate

-(NSString *)nameForSwipeContainer:(XLSwipeContainerController *)swipeContainer
{
    return @"我的活动";
}

-(UIColor *)colorForSwipeContainer:(XLSwipeContainerController *)swipeContainer
{
     return [UIColor colorWithHexString:@"FF5000"];
}
#pragma mark -PrivateMethod
- (void)loadDataWithPage:(NSInteger )page{
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *pageString = [NSString stringWithFormat:@"%ld",page];
    [[MyAPI sharedAPI] loadMyActivityWithPage:pageString result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            dataSource = arrays;
            [self showHint:@"加载完成!!"];
            [self.myActivityTableView reloadData];
            [self hideHud];
        }else{
            [self showHint:@"暂无活动!!"];
            [self hideHud];
        }
        [self.myActivityTableView.mj_header endRefreshing];
    } errorBlock:^(NSError *enginerError) {
        [self showHint:@"加载出错!!"];
        [self hideHud];
        [self.myActivityTableView.mj_header endRefreshing];
    }];
}
@end
