//
//  FinanceAnnalyzeTableViewCell.h
//  ERVICE
//
//  Created by apple on 16/3/16.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FinanceItemModel;
@interface FinanceAnnalyzeTableViewCell : UITableViewCell
- (void)configWithData:(FinanceItemModel *)data;
@end
