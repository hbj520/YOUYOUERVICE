//
//  BannerWebViewController.m
//  ERVICE
//
//  Created by youyou on 16/5/13.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "BannerWebViewController.h"

@interface BannerWebViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)backBtn:(UIBarButtonItem *)sender;

@end

@implementation BannerWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.hidesBackButton = YES;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.bannerUrl]];
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
@end
