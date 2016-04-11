//
//  FamousListTableViewCell.m
//  ERVICE
//
//  Created by youyou on 16/4/7.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "FamousListTableViewCell.h"
#import "starView.h"

#import "FamousTechListModel.h"

#import <SDWebImage/UIImageView+WebCache.h>
@interface FamousListTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *techImageView;
@property (weak, nonatomic) IBOutlet UILabel *techNameLabel;
@property (weak, nonatomic) IBOutlet starView *starView;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
- (IBAction)attentionBtn:(UIButton *)sender;

@end
@implementation FamousListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(FamousTechListModel *)model{
    [self.techImageView sd_setImageWithURL:[NSURL URLWithString:model.techImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.techImageView.layer.masksToBounds = YES;
    self.techNameLabel.text = model.techName;
    [self.starView configWithStarLevel:model.techStars.integerValue/2];
    
    
}
- (IBAction)attentionBtn:(UIButton *)sender {
    if (self.tapBlock) {
        self.tapBlock(sender);
    }
}
@end
