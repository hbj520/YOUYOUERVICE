//
//  CustomerServiceTableViewCell.h
//  ERVICE
//
//  Created by youyou on 16/4/7.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomerServiceModel;
@interface CustomerServiceTableViewCell : UITableViewCell
- (void)configWithData:(CustomerServiceModel *)data;
@end
