//
//  ActivityDetailHeaderTableViewCell.m
//  ERVICE
//
//  Created by apple on 3/23/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "ActivityDetailHeaderTableViewCell.h"
#import "ActivityDetailModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface ActivityDetailHeaderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *apartNum;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end
@implementation ActivityDetailHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(ActivityDetailModel *)model{
    NSString *time = [NSString stringWithFormat:@"%@-%@",model.starttime,model.endtime];
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    self.timeLabel.text = time;
    self.apartNum.text = model.num;
    self.timeLabel.text = model.title;
    
}
@end
