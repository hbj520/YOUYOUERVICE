//
//  TeacherListCollectionViewCell.h
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamousTechListModel;
@interface TeacherListCollectionViewCell : UICollectionViewCell
- (void)configWithData:(FamousTechListModel *)model;
@end
