//
//  TeacherListCollectionViewCell.m
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//
#import "starView.h"
#import "TeacherListCollectionViewCell.h"

#import "FamousTechListModel.h"

#import <SDWebImage/UIImageView+WebCache.h>

@interface TeacherListCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *teachIconImageView;
@property (weak, nonatomic) IBOutlet starView *starView;
@property (weak, nonatomic) IBOutlet UILabel *teachNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@end
@implementation TeacherListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)configWithData:(FamousTechListModel *)model{
[self.teachIconImageView sd_setImageWithURL:[NSURL URLWithString:model.techImage] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    
}];
}
@end
