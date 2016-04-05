//
//  AttentionListTableViewCell.m
//  ERVICE
//
//  Created by 陈 志徽 on 16/4/5.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "AttentionListTableViewCell.h"
#import "starView.h"
@interface AttentionListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *teacherIconImageview;
@property (weak, nonatomic) IBOutlet UILabel *attentionNumLabel;
@property (weak, nonatomic) IBOutlet starView *starView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

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
    
}
@end
