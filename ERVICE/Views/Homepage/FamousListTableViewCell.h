//
//  FamousListTableViewCell.h
//  ERVICE
//
//  Created by youyou on 16/4/7.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamousTechListModel;
@interface FamousListTableViewCell : UITableViewCell
- (void)configWithData:(FamousTechListModel *)model;
@end
