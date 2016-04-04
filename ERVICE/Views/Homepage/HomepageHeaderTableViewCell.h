      //
//  HomepageHeaderTableViewCell.h
//  ERVICE
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ItemBlock)();
@interface HomepageHeaderTableViewCell : UITableViewCell
- (IBAction)myExclusive:(UIButton *)sender;
- (IBAction)businessConsult:(UIButton *)sender;
- (IBAction)specailistConversation:(UIButton *)sender;
- (IBAction)famousExample:(UIButton *)sender;
@property (nonatomic,copy) ItemBlock myExculsiveBlock;
@property (nonatomic,copy) ItemBlock businessBlock;
@property (nonatomic,copy) ItemBlock specialistBlock;
@property (nonatomic,copy) ItemBlock famousBolck;
@end
