//
//  HomepageAnalyzeTableViewCell.h
//  ERVICE
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^ItemClickBlock)();
@interface HomepageAnalyzeTableViewCell : UITableViewCell
@property (nonatomic,copy) ItemClickBlock clickBtnBlock;
@end
