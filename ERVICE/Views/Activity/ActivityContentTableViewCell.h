//
//  ActivityContentTableViewCell.h
//  ERVICE
//
//  Created by apple on 3/22/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ActivityModel;
@interface ActivityContentTableViewCell : UITableViewCell
- (void)configWithData:(ActivityModel *)model;
@end
