//
//  NoticeListTableViewCell.h
//  ERVICE
//
//  Created by youyou on 16/4/12.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoticeModel;
@interface NoticeListTableViewCell : UITableViewCell
- (void)configWithData:(NoticeModel *)model;
@end
