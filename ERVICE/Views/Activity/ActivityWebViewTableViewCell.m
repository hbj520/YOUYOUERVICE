//
//  ActivityWebViewTableViewCell.m
//  ERVICE
//
//  Created by apple on 3/23/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "ActivityWebViewTableViewCell.h"
@interface ActivityWebViewTableViewCell()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
@implementation ActivityWebViewTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithId:(NSString *)articleId{
    NSString *urlString = [NSString stringWithFormat:@"http://36.7.110.253:7777/app/nos_activity_content/%@",articleId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    [self.webView loadRequest:request];
}
@end
