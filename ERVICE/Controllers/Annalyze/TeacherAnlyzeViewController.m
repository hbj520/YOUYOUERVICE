//
//  TeacherAnlyzeViewController.m
//  ERVICE
//
//  Created by apple on 3/21/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "TeacherAnlyzeViewController.h"
#import "TeacherArticleDetailViewController.h"

#import <MJRefresh/MJRefresh.h>

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
                                UITabBarDelegate,
                                UIAlertViewDelegate>
{
    TeacherAnnalyzeModel *annalyzeModel;//数据源
    NSMutableArray *articleDataSource;//老师文章数据源
    NSInteger _page;
    NSString *categoryId;//分类id
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
    _page = 1;
    [self ConfigTableView];
    categoryId = @"";
    //下载数据
    [self loadDataWithTeacherId:self.teacherId page:_page articleId:categoryId];
    
    //添加刷新和下拉加载更多
    [self addRefresh];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - PrivateMethod
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)addRefresh{
    __weak  TeacherAnlyzeViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        if (articleDataSource.count > 0) {
            [articleDataSource removeAllObjects];
        }
        _page = 1;
        [weakself loadDataWithTeacherId:self.teacherId page:_page articleId:categoryId];
    }];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        _page++;
        [weakself loadDataWithTeacherId:self.teacherId page:_page articleId:categoryId];
    }];
}
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
- (void)loadDataWithTeacherId:(NSString *)teacherId page:(NSInteger)page articleId:(NSString *)articleId{
    [self showHudInView:self.view hint:@"加载中..."];
    NSString *nowPage = [NSString stringWithFormat:@"%ld",page];
    [[MyAPI sharedAPI] LecturerDetailWithTeacherId:teacherId articleId:articleId page:nowPage result:^(BOOL success, NSString *msg, id object) {
        
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }

        if (success) {
            annalyzeModel = (TeacherAnnalyzeModel *)object;
            if (!articleDataSource) {
                articleDataSource = [NSMutableArray array];
            }
            [articleDataSource addObjectsFromArray:annalyzeModel.articleArray];
            [self.tableView reloadData];
        }
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self hideHud];
    } errorResult:^(NSError *enginerError) {
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_header endRefreshing];
        [self hideHud];
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
     return   articleDataSource.count;
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
         TeacherCatigoryModel *catemodel = [annalyzeModel.categoryArray objectAtIndex:index];
            [annalyzeModel.articleArray removeAllObjects];
            [articleDataSource removeAllObjects];
            _page = 1;
            [self loadDataWithTeacherId:self.teacherId page:_page articleId:catemodel.categoryId];
            NSLog(@"点击头部%ld按钮",index);
        };
        return cell;
    }else if(indexPath.section == 1){
        AnnalyzeTitleTableViewCell *titleCell = [[[NSBundle mainBundle] loadNibNamed:@"AnnalyzeTitleTableViewCell" owner:self options:nil] lastObject];
        
        [titleCell configWithTitle:annalyzeModel.thisCategory];
        return titleCell;
    }else if (indexPath.section == 2){
        AnnalyzeTableViewCell *contentCell = [[[NSBundle mainBundle] loadNibNamed:@"AnnalyzeTableViewCell" owner:self options:nil] lastObject];
        TeacherItemModel *itemModel = [articleDataSource objectAtIndex:indexPath.row];
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
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}
@end
