//
//  HomepageAnalyzeTableViewCell.m
//  ERVICE
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "HomepageAnalyzeTableViewCell.h"
@interface HomepageAnalyzeTableViewCell()
@property (strong, nonatomic) IBOutlet UILabel *specialistLabel;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end
@implementation HomepageAnalyzeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.bgView.layer.borderWidth = 1.f;
//
//    [self.bgView updateConstraints];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - PrivateMethod

@end
