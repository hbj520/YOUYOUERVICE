//
//  UserInfoTableViewController.m
//  ERVICE
//
//  Created by youyou on 16/4/12.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "UserInfoTableViewController.h"

#import "UserInfo.h"

#import <SDWebImage/UIImageView+WebCache.h>
@interface UserInfoTableViewController ()<UIAlertViewDelegate,UIActionSheetDelegate>
{
    UserInfo *userInfo;
    BOOL _isEdit;//是否未编辑修改状态
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *realNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *mailTextField;
@property (weak, nonatomic) IBOutlet UILabel *userSexLabel;
- (IBAction)backBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UITextField *qqNumTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *editBtn;
- (IBAction)editBtn:(UIBarButtonItem *)sender;

@end

@implementation UserInfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    _isEdit = NO;
    [self createUI];
    //下载数据
    [self loadData];
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
        return 1;
    }else if (section == 2){
        return 3;
    }
    return 0;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2 && indexPath.row == 2) {//性别
        if (_isEdit) {
            [self choseSex];
        }
    }
}
/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

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
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    
//}
#pragma mark - PrivateMethod
- (void)choseSex
{
    [Tools hideKeyBoard];
    UIActionSheet * sheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"男",@"女", nil];
    sheet.tag = 888;
    [sheet showInView:self.view];
}
- (void)updateUserinfo{
    [Tools hideKeyBoard];
    [self showHudInView:self.view hint:@"修改..."];
    [[MyAPI sharedAPI] editUserInfoWithUserName:self.userNameTextField.text email:self.mailTextField.text qqNum:self.qqNumTextField.text name:self.realNameTextField.text sex:self.userSexLabel.text withResult:^(BOOL sucess, NSString *msg) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (sucess) {
            UserInfo *info = [[UserInfo alloc] initWithUserName:self.userNameTextField.text
                                                          email:self.mailTextField.text
                                                          qqNum:self.qqNumTextField.text
                                                           name:self.realNameTextField.text
                                                            sex:self.userSexLabel.text];
            [UserInfo saveUserInfo:info];
            [self showHint:@"修改成功!!!"];
        }else{
            [self showHint:msg];
        }
        [self hideHud];
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"修改出错!!!"];
        [self hideHud];

    }];
}
- (void)enableEdit:(BOOL)isEnable{
    self.userNameTextField.enabled = isEnable;
    self.userSexLabel.enabled = isEnable;
    self.mailTextField.enabled = isEnable;
    self.qqNumTextField.enabled = isEnable;
    self.realNameTextField.enabled = isEnable;
}
- (void)createUI{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:[[Config Instance] getUserIcon]] placeholderImage:[UIImage imageNamed:@"login_icon"]];
    self.iconImageView.layer.masksToBounds = YES;
    UserInfo *userinfo = [UserInfo getUserInfo];
    if (userinfo) {
        self.userNameTextField.text = userinfo.userName;
        self.userSexLabel.text = userinfo.sex;
        self.mailTextField.text = userinfo.email;
        self.qqNumTextField.text = userinfo.qqNum;
        self.realNameTextField.text = userinfo.name;
    }
}
- (void)timeOutAction{//超时处理
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"登录超时" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
}
- (void)loadData{
    [self showHudInView:self.view hint:@"加载中..."];
    [[MyAPI sharedAPI] userInfoWithResult:^(BOOL success, NSString *msg, id object) {
        //登录超时处理
        if ([msg isEqualToString:@"登录超时"]) {
            [self timeOutAction];
        }
        if (success) {
            userInfo = object;
            [UserInfo saveUserInfo:userInfo];
            [self createUI];
        }
        [self hideHud];
    } errorResult:^(NSError *enginerError) {
        [self hideHud];

    }];
}
- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)editBtn:(UIBarButtonItem *)sender {
    _isEdit = !_isEdit;
    if (_isEdit) {
        [self.editBtn setTitle:@"完成"];
        [self enableEdit:_isEdit];
    }else{
        [self.editBtn setTitle:@"修改"];
        [self enableEdit:_isEdit];
        //提交用户修改信息
        [self updateUserinfo];
    }
}
#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {//确定，返回登录
        [LoginHelper loginTimeoutAction];
    }
    
}
#pragma mark - action sheet delegate 
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    [Tools hideKeyBoard];
    if (buttonIndex == 0) {
        self.userSexLabel.text = @"男";
    }else if (buttonIndex == 1){
        self.userSexLabel.text = @"女";
        
    }
}
@end
