//
//  NoticeListTableViewCell.m
//  ERVICE
//
//  Created by youyou on 16/4/12.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "NoticeListTableViewCell.h"
#import "NoticeModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NSDate+Utilities.h"
@interface NoticeListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *noticeImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


@end
@implementation NoticeListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(NoticeModel *)model{
    [self.noticeImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"notice_cellPhotoView"]];
    self.titleLabel.text = model.title;
    NSDate *startdate = [NSDate dateWithTimeIntervalSince1970:model.createTime.integerValue];
    NSDate *enddate = [NSDate dateWithTimeIntervalSince1970:model.fixTime.integerValue];
    
    NSString *time = [NSString stringWithFormat:@"%@~%@",startdate.raziDateString,enddate.raziDateString];
    self.timeLabel.text = time;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
