//
//  AttentionListTableViewCell.h
//  ERVICE
//
//  Created by 陈 志徽 on 16/4/5.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MyTeacherModel;
@interface AttentionListTableViewCell : UITableViewCell
- (void)configWithData:(MyTeacherModel *)data;
@end
