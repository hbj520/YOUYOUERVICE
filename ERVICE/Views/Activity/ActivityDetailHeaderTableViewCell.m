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
#import "starView.h"

#import "NSDate+Utilities.h"
#import "LabelHelper.h"
@interface ActivityDetailHeaderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet starView *starView;

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
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:model.starttime.integerValue];
    NSDate *enddate = [NSDate dateWithTimeIntervalSince1970:model.endtime.integerValue];
    
    NSString *time = [NSString stringWithFormat:@"%@~%@",startdate.raziDateString,enddate.raziDateString];

    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"default"]];
    self.timeLabel.text = time;
    self.titleLabel.text = model.title;
    UILabel *attentionLabel = [[LabelHelper alloc] buildApartLabelWithNumString:model.innum regularString:@" 人已报名"];
    [attentionLabel setFrame:CGRectMake(37, 210, attentionLabel.frame.size.width, attentionLabel.frame.size.height)];
    [self.contentView addSubview:attentionLabel];
    
    [self.starView configWithStarLevel:model.num.integerValue/2];
}
@end
