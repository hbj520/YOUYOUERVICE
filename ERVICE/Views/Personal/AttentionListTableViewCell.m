//
//  AttentionListTableViewCell.m
//  ERVICE
//
//  Created by 陈 志徽 on 16/4/5.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "AttentionListTableViewCell.h"
#import "starView.h"

#import "MyTeacherModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface AttentionListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *teacherIconImageview;
@property (weak, nonatomic) IBOutlet UILabel *attentionNumLabel;
@property (weak, nonatomic) IBOutlet starView *starView;
@property (weak, nonatomic) IBOutlet UILabel *techName;

@end
@implementation AttentionListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(MyTeacherModel *)data{
    [self.teacherIconImageview sd_setImageWithURL:[NSURL URLWithString:data.techImage] placeholderImage:[UIImage imageNamed:@"attention_icon"]];
    self.teacherIconImageview.layer.masksToBounds = YES;
    self.attentionNumLabel.text = [NSString stringWithFormat:@"%ld",data.techFansNum.integerValue];
    self.techName.text = data.techName;
    [self.starView configWithStarLevel:data.techStars.floatValue/2];
    
}
@end
