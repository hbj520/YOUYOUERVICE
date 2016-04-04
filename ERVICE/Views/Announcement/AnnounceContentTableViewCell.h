//
//  AnnounceContentTableViewCell.h
//  ERVICE
//
//  Created by apple on 3/24/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AnnoucementModel;
@interface AnnounceContentTableViewCell : UITableViewCell
- (void)configWithData:(AnnoucementModel *)model;
@end
