//
//  TeacherListCollectionViewCell.m
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//
#import "starView.h"
#import "TeacherListCollectionViewCell.h"
@interface TeacherListCollectionViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *teachIconImageView;
@property (weak, nonatomic) IBOutlet starView *starView;
@property (weak, nonatomic) IBOutlet UILabel *teachNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *attentionBtn;

@end
@implementation TeacherListCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
