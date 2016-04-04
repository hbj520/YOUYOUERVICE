//
//  AttentionTableViewCell.h
//  ERVICE
//
//  Created by apple on 16/3/17.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^attentionBlock)(BOOL);
@class LecturerModel;
@interface AttentionTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;
@property (nonatomic,copy) attentionBlock attentionClickBlock;
- (void)configWithData:(LecturerModel *)model;

@end
