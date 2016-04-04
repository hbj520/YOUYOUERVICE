//
//  ActivityDetailHeaderTableViewCell.h
//  ERVICE
//
//  Created by apple on 3/23/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityDetailModel;
@interface ActivityDetailHeaderTableViewCell : UITableViewCell
- (void)configWithData:(ActivityDetailModel *)model;
@end
