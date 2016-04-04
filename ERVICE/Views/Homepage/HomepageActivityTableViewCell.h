//
//  HomepageActivityTableViewCell.h
//  ERVICE
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ItemBlock)();
@interface HomepageActivityTableViewCell : UITableViewCell
- (IBAction)rookieBtn:(UIButton *)sender;
- (IBAction)newActivityBtn:(UIButton *)sender;
@property (nonatomic,copy) ItemBlock newActivityBlock;
@property (nonatomic,copy) ItemBlock rookieBlock;
@end
