//
//  LoginViewController.m
//  ERVICE
//
//  Created by apple on 3/25/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "LoginViewController.h"
#import "Tools.h"
#import "Marco.h"

#import "AppDelegate.h"
@interface LoginViewController ()
- (IBAction)exitBtn:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UITextField *numberInput;
@property (weak, nonatomic) IBOutlet UITextField *passwordInput;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
- (IBAction)loginBtn:(UIButton *)sender;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    // Do any additional setup after loading the view.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textfieldIsEditing:) name:UITextFieldTextDidChangeNotification object:nil];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [Tools hideKeyBoard];
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
- (void)textfieldIsEditing:(NSNotification *)notification{
    if (self.numberInput.text.length >= 11) {
        [self.loginBtn setImage:[UIImage imageNamed:@"login_ennablebtn"] forState:UIControlStateNormal];
        self.loginBtn.enabled = YES;
    }else{
        [self.loginBtn setImage:[UIImage imageNamed:@"login_unablebtn"] forState:UIControlStateNormal];
        self.loginBtn.enabled = NO;
    }
}
- (void)LoginSuccess{
    ApplicationDelegate.mStorybord = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ApplicationDelegate.window.rootViewController = [ApplicationDelegate.mStorybord instantiateViewControllerWithIdentifier:@"HomeTabBarVC"];
}
- (IBAction)exitBtn:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}


- (IBAction)loginBtn:(UIButton *)sender {
    [Tools hideKeyBoard];    
    NSString *phoneNum = self.numberInput.text;
    NSString *password = self.passwordInput.text;
    [self showHudInView:self.view hint:@"登录中..."];
    NSString *securityString = [Tools loginPasswordSecurityLock:password];
    
    [[MyAPI sharedAPI] LoginWithNumber:phoneNum
                              password:securityString
                                result:^(BOOL sucess, NSString *msg) {
        if (sucess) {
            [self showHint:@"登录成功！"];
            [self LoginSuccess];
        }else{
            [self showHint:msg];
        }
        [self hideHud];
    } errorResult:^(NSError *enginerError) {
        [self showHint:@"登录出错"];
        [self hideHud];
    }];
   
    
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
