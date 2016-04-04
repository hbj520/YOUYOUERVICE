//
//  ActivityContentTableViewCell.m
//  ERVICE
//
//  Created by apple on 3/22/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "ActivityContentTableViewCell.h"
#import "ActivityModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityContentTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//参加人数
@property (weak, nonatomic) IBOutlet UILabel *attenNum;
@property (weak, nonatomic) IBOutlet UIImageView *isHotImage;

@end
@implementation ActivityContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    // [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(ActivityModel *)model{
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"default"]];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.content;
    self.attenNum.text = model.num;
}
@end
