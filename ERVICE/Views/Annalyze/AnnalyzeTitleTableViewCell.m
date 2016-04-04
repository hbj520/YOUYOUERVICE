//
//  AnnalyzeTitleTableViewCell.m
//  ERVICE
//
//  Created by apple on 3/21/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "AnnalyzeTitleTableViewCell.h"
@interface AnnalyzeTitleTableViewCell()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation AnnalyzeTitleTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.bgView.layer.borderColor = [UIColor groupTableViewBackgroundColor].CGColor;
    self.bgView.layer.borderWidth = 1.f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithTitle:(NSString *)title{
    self.titleLabel.text = title;
}
@end
