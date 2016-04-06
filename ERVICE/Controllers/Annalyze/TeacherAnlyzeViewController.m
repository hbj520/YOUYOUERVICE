//
//  TeacherAnlyzeViewController.m
//  ERVICE
//
//  Created by apple on 3/21/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "TeacherAnlyzeViewController.h"
#import "TeacherArticleDetailViewController.h"

#import "TeacherAnnalyzeTableViewCell.h"
#import "AnnalyzeTitleTableViewCell.h"
#import "AnnalyzeTableViewCell.h"
#import "MoveScrollView.h"
#import "CustomGrid.h"

#import "TeacherAnnalyzeModel.h"
#import "TeacherCatigoryModel.h"
#import "TeacherItemModel.h"

@interface TeacherAnlyzeViewController ()<
                                UITableViewDataSource,
                                UITabBarDelegate>
{
    TeacherAnnalyzeModel *annalyzeModel;//数据源
}
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
- (IBAction)backBtn:(UIBarButtonItem *)sender;
@property (nonatomic,strong) NSMutableArray *articles;//文章
@end

@implementation TeacherAnlyzeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.title = self.teacherName; 
    [self ConfigTableView];
    //下载数据
    [self loadDataWithTeacherId:self.teacherId page:@"0" articleId:@""];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PrivateMethod
- (NSMutableArray *)configlImagesAndTitlesWitAnnalyModel:(TeacherAnnalyzeModel *)model{
    NSMutableArray *data = [NSMutableArray array];
    NSMutableArray *imageArray = [NSMutableArray array];
    NSMutableArray *titleArray = [NSMutableArray array];
    for (TeacherCatigoryModel *categoryModel in model.categoryArray) {
        [imageArray addObject:categoryModel.image];
        [titleArray addObject:categoryModel.title];
    }
    [data addObject:imageArray];
    [data addObject:titleArray];
    return data;
    
}
- (void)loadDataWithTeacherId:(NSString *)teacherId page:(NSString *)page articleId:(NSString *)articleId{
//    if (annalyzeModel) {
//        annalyzeModel = nil;
//    }
    [[MyAPI sharedAPI] LecturerDetailWithTeacherId:teacherId articleId:articleId page:page result:^(BOOL success, NSString *msg, id object) {
        if (success) {
            annalyzeModel = (TeacherAnnalyzeModel *)object;
            [self.tableView reloadData];
        }
    } errorResult:^(NSError *enginerError) {
        
    }];
}
- (void)ConfigTableView{
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[TeacherAnnalyzeTableViewCell class] forCellReuseIdentifier:@"teacherAnnalyzeId1"];
    [self.tableView registerClass:[AnnalyzeTitleTableViewCell class] forCellReuseIdentifier:@"teacherAnnalyzeId2"];
    [self.tableView registerClass:[AnnalyzeTableViewCell class] forCellReuseIdentifier:@"teacherAnnalyzeId3"];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
        return 1;
    }else if(section == 2){
     return   annalyzeModel.articleArray.count;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        TeacherAnnalyzeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"TeacherAnnalyzeTableViewCell" owner:self options:nil] lastObject];
        //
       NSMutableArray *category = [self configlImagesAndTitlesWitAnnalyModel:annalyzeModel];
        [cell configWithNormalImgArr:category[0] showGridArr:category[1] isShowTitles:YES];
        cell.mScrollView.showsHorizontalScrollIndicator = NO;
        cell.mScrollView.showsVerticalScrollIndicator = NO;
        cell.clickItemBlock = ^(NSInteger index){
            [annalyzeModel.categoryArray objectAtIndex:index];
            NSLog(@"点击头部%ld按钮",index);
        };
        return cell;
    }else if(indexPath.section == 1){
        AnnalyzeTitleTableViewCell *titleCell = [[[NSBundle mainBundle] loadNibNamed:@"AnnalyzeTitleTableViewCell" owner:self options:nil] lastObject];
        
        [titleCell configWithTitle:annalyzeModel.thisCategory];
        return titleCell;
    }else if (indexPath.section == 2){
        AnnalyzeTableViewCell *contentCell = [[[NSBundle mainBundle] loadNibNamed:@"AnnalyzeTableViewCell" owner:self options:nil] lastObject];
        TeacherItemModel *itemModel = [annalyzeModel.articleArray objectAtIndex:indexPath.row];
        [contentCell configWithdata:itemModel];
        return contentCell;
    }
    return nil;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    TeacherItemModel *itemModel = [annalyzeModel.articleArray objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"TeacherArticleSegue" sender:itemModel.itemId];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }else if (indexPath.section == 1){
        return 44;
    }else if (indexPath.section == 2){
        return 110;
    }
    return 142.;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }
    return 5;
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    TeacherArticleDetailViewController *articleVC = (TeacherArticleDetailViewController *)segue.destinationViewController;
    articleVC.articleId = (NSString *)sender;
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}


- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
