//
//  TeacherArticleDetailViewController.m
//  ERVICE
//
//  Created by apple on 3/31/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "TeacherArticleDetailViewController.h"
#import "XMShareView.h"

@interface TeacherArticleDetailViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *teacherArticleWebView;
@property (nonatomic, strong) XMShareView *shareView;
- (IBAction)backBtn:(UIBarButtonItem *)sender;
- (IBAction)sharedBtn:(UIBarButtonItem *)sender;


@end

@implementation TeacherArticleDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    // Do any additional setup after loading the view.
    NSString *urlString = [NSString stringWithFormat:@"http://60.173.235.34:9999/svnupdate/app/nos_teacher_articleinfo/%@",self.articleId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.teacherArticleWebView loadRequest:request];
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
        self.shareView.shareTitle = [NSString stringWithFormat:@"http://60.173.235.34:9999/svnupdate/app/nos_teacher_articleinfo/%@",self.articleId];
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
