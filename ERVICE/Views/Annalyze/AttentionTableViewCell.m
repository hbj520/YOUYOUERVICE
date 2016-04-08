//
//  AttentionTableViewCell.m
//  ERVICE
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "AttentionTableViewCell.h"
#import "starView.h"
#import "LecturerModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface AttentionTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *lecturerIcon;
@property (weak, nonatomic) IBOutlet UILabel *lecturerName;
@property (weak, nonatomic) IBOutlet UILabel *lecturerDes;
@property (weak, nonatomic) IBOutlet UILabel *attentionCount;
@property (weak, nonatomic) IBOutlet starView *starView;
- (IBAction)attentionBtn:(UIButton *)sender;
@end
@implementation AttentionTableViewCell

- (void)awakeFromNib {
    // Initialization code
    // [self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)attentionBtn:(UIButton *)sender {
    if (self.attentionClickBlock) {
        self.attentionClickBlock(self.attentionBtn.selected);
    }

}
- (void)configWithData:(LecturerModel *)model{
    [self.lecturerIcon sd_setImageWithURL:[NSURL URLWithString:model.lecturerIcon] placeholderImage:[UIImage imageNamed:@"financeicon"]];
    self.lecturerIcon.layer.masksToBounds = YES;
    self.lecturerName.text = model.username;
    self.lecturerDes.text = model.lecDescription;
    self.attentionCount.text = model.num;
    [self.starView configWithStarLevel:model.star.floatValue/2];
    self.attentionBtn.selected = model.isAttention;
    if (model.isAttention) {
        [self.attentionBtn setImage:[UIImage imageNamed:@"notattention"] forState:UIControlStateNormal];
    }else{
         [self.attentionBtn setImage:[UIImage imageNamed:@"attention"] forState:UIControlStateNormal];
    }
}
@end
