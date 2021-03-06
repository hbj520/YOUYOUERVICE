//
//  FinanceAnnalyzeTableViewCell.m
//  ERVICE
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "FinanceAnnalyzeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "SelectImageView.h"
#import "FinanceItemModel.h"

#import "LabelHelper.h"

@interface FinanceAnnalyzeTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *exchangeImage;

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
    [self.exchangeImage sd_setImageWithURL:[NSURL URLWithString:data.image] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage *img = [Tools imageCompressForSize:image targetSize:CGSizeMake(60, 60)];
        self.exchangeImage.image = img;
    }];

    self.titleLabel.text = data.exname;
    UILabel *attentionLabel = [[LabelHelper alloc] buildApartLabelWithNumString:data.num regularString:@" 人参加"];
    [attentionLabel setFrame:CGRectMake(128, 61, attentionLabel.frame.size.width, attentionLabel.frame.size.height)];
    [self.contentView addSubview:attentionLabel];
}
@end
