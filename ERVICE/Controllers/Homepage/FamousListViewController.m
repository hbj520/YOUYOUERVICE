//
//  FamousListViewController.m
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "FamousListViewController.h"

@interface FamousListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FamousListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //下载数据前几名
    [self loadData];
    //下载前几页
    [self loadDataWithPage:0];
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
- (void)loadData{
    //下载排名前几名老师
    [[MyAPI sharedAPI] famousTopThreeWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        
    } errorResult:^(NSError *enginerError) {
        
    }];
   
}
- (void)loadDataWithPage:(NSInteger)page{
    NSString *pageNum = [NSString stringWithFormat:@"%ld",page];
    //下载名师列表
    [[MyAPI sharedAPI] famousListWithPage:pageNum result:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        
        
    } errorResult:^(NSError *enginerError) {
        
    }];
}
@end
