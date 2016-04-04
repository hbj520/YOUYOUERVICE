//
//  AnnouncementDetaiViewController.m
//  ERVICE
//
//  Created by apple on 4/1/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "AnnouncementDetaiViewController.h"

@interface AnnouncementDetaiViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
- (IBAction)back:(UIBarButtonItem *)sender;

@end

@implementation AnnouncementDetaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
    NSString *urlString = [NSString stringWithFormat:@"http://36.7.110.253:7777/app/nos_notice_info/%@",self.articleId];
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

- (IBAction)back:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
@end
