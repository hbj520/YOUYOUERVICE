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
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:exchangeModel.exchangeImageurl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage *img = [Tools imageCompressForSize:image targetSize:CGSizeMake(66, 66)];
        self.imageView.image = img;
    }];

    self.titleLable.text = exchangeModel.exchangName;
}
@end
