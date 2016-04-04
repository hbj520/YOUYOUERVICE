//
//  ThreeCollectionViewCell.m
//  ERVICE
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "ThreeCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HomepageExchangeModel.h"
@implementation ThreeCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)configWithData:(HomepageExchangeModel *)exchangeModel{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:exchangeModel.exchangeImageurl] placeholderImage:[UIImage imageNamed:@"default"]];
    self.titleLable.text = exchangeModel.exchangName;
}
@end
