//
//  FamousListTableViewCell.h
//  ERVICE
//
//  Created by youyou on 16/4/7.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^TapAttentionBlock)(id);
@class FamousTechListModel;
@interface FamousListTableViewCell : UITableViewCell
@property (nonatomic,copy) TapAttentionBlock tapBlock;
- (void)configWithData:(FamousTechListModel *)model;
@end
