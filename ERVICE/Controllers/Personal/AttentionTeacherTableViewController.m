//
//  AttentionTeacherTableViewController.m
//  ERVICE
//
//  Created by apple on 4/1/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "AttentionTeacherTableViewController.h"
#import "starView.h"
#import "MyTeacherModel.h"

#import <SDWebImage/UIImageView+WebCache.h>
@interface AttentionTeacherTableViewController ()
{
    NSMutableArray *dataSource;
}
- (IBAction)backBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet starView *starView;
@property (weak, nonatomic) IBOutlet UIImageView *myTechIconImageView;
@property (weak, nonatomic) IBOutlet UILabel *attentionLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *gradutedSchoolLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *publilshArticleLabel;
- (IBAction)attentionBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@end

@implementation AttentionTeacherTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    [self creatUI];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 4;
    }
    return 1;
}
#pragma mark - privateMethod
- (void)creatUI{
    [self.myTechIconImageView sd_setImageWithURL:[NSURL URLWithString:self.myTech.techImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.myTechIconImageView.layer.masksToBounds = YES;
    self.attentionLabel.text = self.myTech.techFansNum;
    [self.starView configWithStarLevel:self.myTech.techStars.integerValue/2];
    
     self.nameLabel.text = [NSString stringWithFormat:@"姓名：%@",self.myTech.techName];
    self.gradutedSchoolLabel.text = [NSString stringWithFormat:@"毕业院校：%@",self.myTech.techGratudeSchool];
    self.publilshArticleLabel.text = [NSString stringWithFormat:@"发表文章：%@",self.myTech.techNewArticle];
    self.locationLabel.text = [NSString stringWithFormat:@"所在位置：%@",@"合肥市"];
    
}
- (void)noAttentionAction{
    [self showHint:@"取消关注成功"];
    [self.navigationController popViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noattentionsuccess" object:nil];
}
#pragma mark - UITableViewDelegate
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSString *reuserId = [NSString stringWithFormat:@"reuseId%ld",indexPath.row+indexPath.section];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuserId forIndexPath:indexPath];
//
//    if (indexPath.section == 0) {
//        //配置我的老师信息
//        UIImageView *iconImageView = [cell viewWithTag:10];
//        UILabel *attentionNumLabel = [cell viewWithTag:11];
//        starView *starView = [cell viewWithTag:12];
//        [iconImageView sd_setImageWithURL:[NSURL URLWithString:self.myTech.techImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//            
//        }];
//        iconImageView.layer.masksToBounds = YES;
//        attentionNumLabel.text = self.myTech.techName;
//        [starView configWithStarLevel:self.myTech.techStars.integerValue/2];
//        
//    }else {
//        if (indexPath.row == 0) {//姓名
//            UILabel *nameLabel = [cell viewWithTag:10];
//            nameLabel.text = [NSString stringWithFormat:@"姓名：%@",self.myTech.techName];
//        }else if (indexPath.row == 1){//毕业院校
//            UILabel *eduSchool = [cell viewWithTag:10];
//            eduSchool.text = [NSString stringWithFormat:@"毕业院校：%@",self.myTech.techGratudeSchool];
//        }else if (indexPath.row == 2){
//            UILabel *locationLabel = [cell viewWithTag:10];
//            locationLabel.text = [NSString stringWithFormat:@"所在位置：%@",@"合肥市"];
//        }else if (indexPath.row == 3){
//            UILabel *publishArticle = [cell viewWithTag:10];
//            publishArticle.text = [NSString stringWithFormat:@"发表文章：%@",self.myTech.techNewArticle];
//        }
//    }
//    
//    return cell;
//}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

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
- (IBAction)attentionBtn:(UIButton *)sender {
    [[MyAPI sharedAPI] noAttentionWithLecturerId:self.myTech.techId result:^(BOOL sucess, NSString *msg) {
        if (sucess) {
            [self noAttentionAction];
        }else{
            [self showHint:msg];
        }
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"取消关注出错！！"];
    }];
}
@end
