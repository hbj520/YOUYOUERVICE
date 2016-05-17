//
//  HomepageViewController.m
//  ERVICE
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "HomepageViewController.h"
#import "AttentionTeacherListViewController.h"
#import "FamousListViewController.h"
#import "CustomerServiceViewController.h"
#import "BannerWebViewController.h"

#import "SDCycleScrollView.h"
#import "HomepageHeaderTableViewCell.h"
#import "HomepageActivityTableViewCell.h"
#import "HomepageAnalyzeTableViewCell.h"
#import "ThreeTableViewCell.h"
#import "TeacherAnnalyzeTableViewCell.h"
#import "Tools.h"
#import "Marco.h"
#import "FinanceAnnalyzeViewController.h"
#import "AppDelegate.h"
#import <MJRefresh/MJRefresh.h>

#import "HomepageBannerModel.h"
#import "HomepageExchangeModel.h"
#import "BBBadgeBarButtonItem.h"
#import "TeacherAnlyzeViewController.h"
#import "FamousTechListModel.h"
#import "AttentionViewController.h"
@interface HomepageViewController ()<UITableViewDataSource,
                                     UITableViewDelegate,
                                     SDCycleScrollViewDelegate,
                                     HomepageTabelViewCellDelegate,
                                     UIAlertViewDelegate>
{
    SDCycleScrollView *_headerView;
    NSMutableArray *bannerData;//滚动视图数据
    NSMutableArray *exchangeData;//交易所数据
    NSInteger _collectionLines;
    BBBadgeBarButtonItem *_chatBtn;
    UIView *footView;
    NSMutableArray * _ThreeArray;
   // NSMutableArray * _arrayTech;
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation HomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //下载数据
    [self loadData];
    [self loadThreeData];
    //设置navtitle
    [self setNavTitle];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    //[self createTeacherThree];
     self.tableView.tableFooterView = footView;
    //添加刷新
    [self addRefresh];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - privateMethod
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)addRefresh{
    __weak  HomepageViewController *weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakself loadData];
        [weakself loadThreeData];
    }];
}

- (void)loadThreeData{
    //下载排名前几名老师
    
    [[MyAPI sharedAPI] famousTopThreeWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        if (success) {
            _ThreeArray = arrays;
            [self createTeacherThree];
            
        }else{
            NSLog(@"load failed");
        }
      
    } errorResult:^(NSError *enginerError) {
        
        NSLog(@"error result");
    }];
    
}
- (void)loadData{
    [self showHudInView:self.view hint:@"加载中..."];
    [[MyAPI sharedAPI] getHomepageDataWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (success) {
            bannerData = arrays[0];
            exchangeData = arrays[1];
            _collectionLines = [Tools simulateLinesWithArray:exchangeData.count
withList:3];
            //头部滚动视图
            [self configPageViews];
            [self congfigTableView];
            [self.tableView reloadData];
            [self hideHud];
        }else{
            [self hideHud];
        }
        [self.tableView.mj_header endRefreshing];
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"下载出错"];
        [self hideHud];
        [self.tableView.mj_header endRefreshing];

    }];
    
//    [[MyAPI sharedAPI] famousTopThreeWithResult:^(BOOL success, NSString *msg, NSMutableArray *arrays) {
//        if (success) {
//            _ThreeArray = arrays;
//            
//        }
//        
//    } errorResult:^(NSError *enginerError) {
//        
//    }];

}
- (void)configPageViews{
    NSMutableArray *imagArray = [NSMutableArray array];
    for (HomepageBannerModel *model in bannerData) {
        [imagArray addObject:model.imageUrl];
    }
    _headerView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0,ScreenWidth,160) imageURLStringsGroup:imagArray];
    _headerView.delegate = self;
    
    
}
- (void)congfigTableView{
    [self.tableView registerClass:[HomepageHeaderTableViewCell class] forCellReuseIdentifier:@"homepageReusedId1"];
    [self.tableView registerClass:[HomepageActivityTableViewCell class] forCellReuseIdentifier:@"homepageReused2"];
    [self.tableView registerClass:[HomepageAnalyzeTableViewCell class] forCellReuseIdentifier:@"homepageReused3"];
    [self.tableView registerClass:[ThreeTableViewCell class] forCellReuseIdentifier:@"homepageReused4"];
    //[self.tableView registerClass:[TeacherAnnalyzeTableViewCell class] forCellReuseIdentifier:@"homepageReused4"];
    
}
- (void)setNavTitle{
    NSString *navTitle = @"V家金服";
    NSDictionary *attributeDict = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,[UIColor darkGrayColor],NSForegroundColorAttributeName, nil];
    self.navigationController.navigationBar.titleTextAttributes = attributeDict;
    self.navigationItem.title = navTitle;
    [self addChatBtn];
}
- (void)addChatBtn{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 25, 25);
    [btn setImage:[UIImage imageNamed:@"chat_icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(chatAct:) forControlEvents:UIControlEventTouchUpInside];
    _chatBtn = [[BBBadgeBarButtonItem alloc] initWithCustomUIButton:btn];
    _chatBtn.badgeFont = [UIFont systemFontOfSize:10.0f];
    _chatBtn.badgeOriginX = 15.5;
    _chatBtn.badgeOriginY = -2.5;
    _chatBtn.badgePadding = 2;
    _chatBtn.badgeValue = @"0";
    
    NSMutableArray *arryBtn = [NSMutableArray arrayWithObjects:_chatBtn, nil];
    self.navigationItem.leftBarButtonItems = arryBtn;
}
- (void)chatAct:(id)sender{
    [self performSegueWithIdentifier:@"chatlistSegue" sender:nil];
}
//点击我的专属
- (void)clickMyExculsive{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    AttentionTeacherListViewController *teacherListVC = (AttentionTeacherListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"attentionTeachListId"];
    [self.navigationController pushViewController:teacherListVC animated:YES];
}
//点击业务咨询
- (void)clickBusiness{
    [self performSegueWithIdentifier:@"CustomerServiceSegue" sender:nil];
}
//点击专家会诊
- (void)clickSpecail{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Personal" bundle:nil];
    AttentionTeacherListViewController *teacherListVC = (AttentionTeacherListViewController *)[storyboard instantiateViewControllerWithIdentifier:@"attentionTeachListId"];
    teacherListVC.isSpecail = YES;
    [self.navigationController pushViewController:teacherListVC animated:YES];
}
//点击名人榜单
- (void)clickFamous{
    [self performSegueWithIdentifier:@"FamousListSegue" sender:nil];
}
#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2) {
        return 2;
    }
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HomepageHeaderTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HomepageHeaderTableViewCell" owner:self options:nil]lastObject];
        //我的专属，业务咨询，名人榜单，专家会诊
        __weak HomepageViewController *weakself = self;
        cell.myExculsiveBlock = ^(){
            [weakself clickMyExculsive];
        };
        cell.businessBlock = ^(){
            [weakself clickBusiness];
        };
        cell.specialistBlock = ^(){
            [weakself clickSpecail];
        };
        cell.famousBolck = ^(){
            [weakself clickFamous];
        };
        return cell;
    }else if (indexPath.section == 1){
        HomepageActivityTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HomepageActivityTableViewCell" owner:self options:nil] lastObject];
        return cell;
        
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            HomepageAnalyzeTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"HomepageAnalyzeTableViewCell" owner:self options:nil] lastObject];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else if (indexPath.row == 1){
           ThreeTableViewCell *cell = [[ThreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"homepageReused4"];
            cell.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.modelsArray = exchangeData;
            return cell;
        }
        
        
    }
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return _headerView;
    }
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 200.;
    }else if (section == 1){
        return 2.;
    }else{
        return 20.;
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100.;
    }else if (indexPath.section == 1){
        return 38.;
    }else if(indexPath.section == 2){
        if (indexPath.row == 0) {
            return 38.;
        }else{
            return 150;
        }
    }
    return 46;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 0) {
        //点击进入分析页面
//        [self performSegueWithIdentifier:@"financeSegue" sender:nil];
        self.tabBarController.selectedIndex = 1;
    }
}
#pragma mark -SDCycleScrollViewDelegate
//点击头部滚动视图
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    HomepageBannerModel *model = [bannerData objectAtIndex:index];
    if (model.link.length > 0) {//有链接
        [self performSegueWithIdentifier:@"bannerSegue" sender:model.link];
    }
}
#pragma mark - TapCollectionCellDelegate
- (void)TapCollectionViewCellDelegate:(HomepageAnalyzeModel *)analyzeModel tapIndexPath:(NSIndexPath *)indexPath{
    HomepageExchangeModel *exModel = exchangeData[indexPath.row];
    
    AttentionViewController *viewController = [ApplicationDelegate.annalyzeStorybord instantiateViewControllerWithIdentifier:@"CompanyAnnalyzeId"];
    viewController.exid = exModel.exchangeId;
    viewController.exName = exModel.exchangName;
    [self.navigationController pushViewController:viewController animated:YES];
}
#pragma mark - SegueDelegate

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"financeSegue"]) {
        FinanceAnnalyzeViewController *financeVC = (FinanceAnnalyzeViewController *)segue.destinationViewController;
        
    }else if ([segue.identifier isEqualToString:@"bannerSegue"]){
        BannerWebViewController *bannerWebVC = segue.destinationViewController;
        bannerWebVC.bannerUrl = sender;
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}
#pragma mark -- CreateTeacherThree
/**
 先实现功能
 *  推荐讲师前三名
 */
- (void)createTeacherThree
{
    

    footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    footView.backgroundColor = [UIColor colorWithRed:242 green:243 blue:244 alpha:1];
    UIImageView * topView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 55, 16)];
    topView.image = [UIImage imageNamed:@"a1_27"];
   // FamousTechListModel * model = [[FamousTechListModel alloc] init];
   // NSMutableArray * array1 = [model buildData:_ThreeArray];
    [footView addSubview:topView];
    for(int i =0;i<_ThreeArray.count;i++){
        FamousTechListModel * model = [_ThreeArray objectAtIndex:i];
        //[_arrayTech addObject:model];
        CGFloat orginH = (i+1)*8+ i*61 + 38;
        UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(0, orginH, self.view.frame.size.width, 61)];
        btn.tag = 10 + i;
        btn.backgroundColor = [UIColor whiteColor];
        [btn addTarget:self action:@selector(pushDetailview:) forControlEvents:UIControlEventTouchUpInside];
        UIImageView * img = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 40, 40)];
        img.backgroundColor = [UIColor blueColor];
        NSURL * urlimg = [NSURL URLWithString:model.techImage];
        [img.layer setMasksToBounds:YES];
        img.layer.cornerRadius = 20;
        [img sd_setImageWithURL:urlimg];
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 70, 25)];
        title.textColor = [UIColor blackColor];
        title.font =[UIFont systemFontOfSize:17];
        title.text = model.techName;

        UILabel * detail = [[UILabel alloc] initWithFrame:CGRectMake(80, 40, 200, 20)];
        detail.textColor = [UIColor blackColor];
        detail.font = [UIFont systemFontOfSize:12];
        detail.text = model.techDes;
//        if(i==0){
//            model = array1[0];
//           // NSArray * data = _ThreeArray[0];
//            //[model buildData:data];
//            NSString * imgPath = model.techImage;
//            
//            NSURL * urlimg = [NSURL URLWithString:model.techImage];
//            [img.layer setMasksToBounds:YES];
//            img.layer.cornerRadius = 20;
//            [img sd_setImageWithURL:urlimg];
//            title.text = model.techName;
//            detail.text = model.techDes;
//        }else if (i==1){
//           // model = _ThreeArray[1];
//           model = array1[1];
//            
//            //[model buildData:data];
//            // NSString * imgPath = model.techImage;
//            NSURL * urlimg = [NSURL URLWithString:model.techImage];
//            [img.layer setMasksToBounds:YES];
//            img.layer.cornerRadius = 20;
//            [img sd_setImageWithURL:urlimg];
//            title.text = model.techName;
//            detail.text = model.techDes;
//        }else if (i==2){
//            //model = _ThreeArray[2];
//           // NSArray * data = _ThreeArray[2];
//            //[model buildData:data];
//            model = array1[2];
//            NSString * imgPath = model.techImage;
//           
//            NSURL * urlimg = [NSURL URLWithString:imgPath];
//            [img.layer setMasksToBounds:YES];
//            img.layer.cornerRadius = 20;
//            [img sd_setImageWithURL:urlimg];
//            title.text = model.techName;
//            detail.text = model.techDes;
//        }
        [btn addSubview:img];
        [btn addSubview:title];
        [btn addSubview:detail];
        [footView addSubview:btn];
    }
    self.tableView.tableFooterView = footView;
}

- (void)pushDetailview:(UIButton*)sender
{
     NSInteger i = sender.tag - 10;
//    FamousTechListModel * model = [[FamousTechListModel alloc] init];
//     NSMutableArray * array1 = [model buildData:_ThreeArray];
   
    FamousTechListModel * model  = [_ThreeArray objectAtIndex:i];
   // model = _ThreeArray[i];
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Annalyze" bundle:nil];
 TeacherAnlyzeViewController *teacherDetailVC = (TeacherAnlyzeViewController *)[storybord instantiateViewControllerWithIdentifier:@"TeacherDetailStorybordId"];
    NSString * str1 = model.techId;
    NSString * str2 = model.techName;
    teacherDetailVC.teacherId = str1;
 teacherDetailVC.teacherName =  str2;
     [self.navigationController pushViewController:teacherDetailVC animated:YES];
//    if (sender.tag == 10) {
//        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Annalyze" bundle:nil];
//        TeacherAnlyzeViewController *teacherDetailVC = (TeacherAnlyzeViewController *)[storybord instantiateViewControllerWithIdentifier:@"TeacherDetailStorybordId"];
//        teacherDetailVC.teacherId = @"89";
//        teacherDetailVC.teacherName = @"李放放";
//        [self.navigationController pushViewController:teacherDetailVC animated:YES];
//    }else if (sender.tag == 11){
//        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Annalyze" bundle:nil];
//        TeacherAnlyzeViewController *teacherDetailVC = (TeacherAnlyzeViewController *)[storybord instantiateViewControllerWithIdentifier:@"TeacherDetailStorybordId"];
//        teacherDetailVC.teacherId = @"178";
//        teacherDetailVC.teacherName = @"张教授";
//        [self.navigationController pushViewController:teacherDetailVC animated:YES];
//    }else if (sender.tag == 12){
//        UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Annalyze" bundle:nil];
//        TeacherAnlyzeViewController *teacherDetailVC = (TeacherAnlyzeViewController *)[storybord instantiateViewControllerWithIdentifier:@"TeacherDetailStorybordId"];
//        teacherDetailVC.teacherId = @"182";
//        teacherDetailVC.teacherName = @"孙晓晓李";
//        [self.navigationController pushViewController:teacherDetailVC animated:YES];
//        
//    }
}

@end
