//
//  TeacherAnnalyzeTableViewCell.m
//  ERVICE
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "TeacherAnnalyzeTableViewCell.h"
#import "MoveScrollView.h"
#import "Marco.h"
@interface TeacherAnnalyzeTableViewCell()


@end
@implementation TeacherAnnalyzeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    // [self setTranslatesAutoresizingMaskIntoConstraints:NO];
    self.mScrollView.delegate = self;
    self.mScrollView.gridClickBlock = ^(CustomGrid *grid){
        
        if (self.clickItemBlock) {
            self.clickItemBlock(grid.gridIndex);
        }
    };
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithNormalImgArr:(NSMutableArray *)imgaArr showGridArr:(NSMutableArray *)showGridArr isShowTitles:(BOOL)isShowTitle{

    self.mScrollView.normalImgArr = imgaArr;
    self.mScrollView.highlightImgArr = imgaArr;
    self.mScrollView.showGridArray = showGridArr;
    [self.mScrollView drawGridIsShowTitle:isShowTitle withGridFrame:CGRectMake(0, 0, 100, 100)];
}
@end
