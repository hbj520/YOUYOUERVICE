//
//  MyActivityHeaderTableViewCell.m
//  ERVICE
//
//  Created by apple on 3/22/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "MyActivityHeaderTableViewCell.h"

@implementation MyActivityHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithNormalImgArr:(NSMutableArray *)imgaArr showGridArr:(NSMutableArray *)showGridArr isShowTitle:(BOOL)isShowTitle{
    self.mScrollView.normalImgArr = imgaArr;
    self.mScrollView.highlightImgArr = imgaArr;
    self.mScrollView.showGridArray = showGridArr;
    [self.mScrollView drawGridIsShowTitle:isShowTitle withGridFrame:CGRectMake(0, 0, 100, 100)];
}
@end
