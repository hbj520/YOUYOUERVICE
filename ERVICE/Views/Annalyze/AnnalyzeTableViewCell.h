//
//  AnnalyzeTableViewCell.h
//  ERVICE
//
//  Created by apple on 3/21/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TeacherItemModel;
@interface AnnalyzeTableViewCell : UITableViewCell
- (void)configWithdata:(TeacherItemModel *)data;
@end
