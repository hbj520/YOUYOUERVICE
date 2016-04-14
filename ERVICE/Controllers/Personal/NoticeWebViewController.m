//
//  NoticeWebViewController.m
//  ERVICE
//
//  Created by youyou on 16/4/12.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "NoticeWebViewController.h"

#import "XMShareView.h"

@interface NoticeWebViewController ()
- (IBAction)backBtn:(UIBarButtonItem *)sender;

- (IBAction)sharedBtn:(UIBarButtonItem *)sender;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) XMShareView *shareView;

@end

@implementation NoticeWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem hidesBackButton];
    // Do any additional setup after loading the view.
    NSString *urlString = [NSString stringWithFormat:@"http://60.173.235.34:9999/svnupdate/app/nos_sysnotice_info/%@/%@",self.noticeId,KToken];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
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

- (IBAction)backBtn:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)sharedBtn:(UIBarButtonItem *)sender {
    if(!self.shareView){
        
        self.shareView = [[XMShareView alloc] initWithFrame:self.view.bounds];
        self.shareView.shareTitle = [NSString stringWithFormat:@"http://60.173.235.34:9999/svnupdate/app/nos_sysnotice_info/%@",self.noticeId];
        self.shareView.alpha = 0.0;
        
        //self.shareView.shareTitle = NSLocalizedString(@"分享标题", nil);
        
        //self.shareView.shareText = NSLocalizedString(@"分享内容", nil);
        
        //self.shareView.shareUrl = @"http://amonxu.com";
        
        [self.view addSubview:self.shareView];
        
        [UIView animateWithDuration:1 animations:^{
            self.shareView.alpha = 1.0;
        }];
        
        
    }else{
        [UIView animateWithDuration:1 animations:^{
            self.shareView.alpha = 1.0;
        }];
        
    }
}
@end
