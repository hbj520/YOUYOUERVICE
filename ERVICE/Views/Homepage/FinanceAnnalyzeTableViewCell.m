//
//  FinanceAnnalyzeTableViewCell.m
//  ERVICE
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "FinanceAnnalyzeTableViewCell.h"
#import "SelectImageView.h"
#import "FinanceItemModel.h"
@interface FinanceAnnalyzeTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *apartNum;

@end
@implementation FinanceAnnalyzeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    // [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(FinanceItemModel *)data{
    self.titleLabel.text = data.exname;
    self.apartNum.text = data.num;
}
@end
