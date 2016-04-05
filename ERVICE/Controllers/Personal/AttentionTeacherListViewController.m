//
//  AttentionTeacherListViewController.m
//  ERVICE
//
//  Created by 陈 志徽 on 16/4/5.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "AttentionTeacherListViewController.h"

@interface AttentionTeacherListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AttentionTeacherListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //下载数据
    [self loadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma  mark - PrivateMethod
- (void)loadData{
    [[MyAPI sharedAPI] myTeacherWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        
        if (success) {
            
        }else{
            
        }
        
    } errorResult:^(NSError *enginerError) {
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
