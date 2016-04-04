//
//  TeacherAnnalyzeTableViewCell.h
//  ERVICE
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoveScrollView.h"
typedef void (^ClickItemBlock)(NSInteger);
@interface TeacherAnnalyzeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet MoveScrollView *mScrollView;
@property (nonatomic,copy) ClickItemBlock clickItemBlock;
- (void)configWithNormalImgArr:(NSMutableArray *)imgaArr showGridArr:(NSMutableArray *)showGridArr isShowTitles:(BOOL)isShowTitle;
@end
