//
//  MyActivityHeaderTableViewCell.h
//  ERVICE
//
//  Created by apple on 3/22/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoveScrollView.h"
@interface MyActivityHeaderTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MoveScrollView *mScrollView;
- (void)configWithNormalImgArr:(NSMutableArray *)imgaArr showGridArr:(NSMutableArray *)showGridArr isShowTitle:(BOOL)isShowTitle;
@end
