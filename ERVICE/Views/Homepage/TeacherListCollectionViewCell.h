//
//  TeacherListCollectionViewCell.h
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^AttentionBtnBlock)(id);
@class FamousTechListModel;
@interface TeacherListCollectionViewCell : UICollectionViewCell
@property (nonatomic,copy) AttentionBtnBlock attentionBlock;
- (void)configWithData:(FamousTechListModel *)model;
@end
