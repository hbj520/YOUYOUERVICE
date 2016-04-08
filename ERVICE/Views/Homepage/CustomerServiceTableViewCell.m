//
//  CustomerServiceTableViewCell.m
//  ERVICE
//
//  Created by youyou on 16/4/7.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "CustomerServiceTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

#import "starView.h"

#import "CustomerServiceModel.h"

@interface CustomerServiceTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *customerSerIcon;
@property (weak, nonatomic) IBOutlet UILabel *customerSerUserNameLabel;
@property (weak, nonatomic) IBOutlet starView *starView;

@end

@implementation CustomerServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
- (void)configWithData:(CustomerServiceModel *)data{
    [self.customerSerIcon sd_setImageWithURL:[NSURL URLWithString:data.imageurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
    }];
    self.customerSerIcon.layer.masksToBounds = YES;
    self.customerSerUserNameLabel.text = data.username;
    [self.starView configWithStarLevel:data.star.integerValue/2];
}
@end
