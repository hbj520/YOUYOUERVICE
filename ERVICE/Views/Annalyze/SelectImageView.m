//
//  SelectImageView.m
//  ERVICE
//
//  Created by apple on 3/21/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "SelectImageView.h"
#import "FinanceAnnalyzeTableViewCell.h"
@implementation SelectImageView
- (instancetype)initWithImage:(UIImage *)image{
    self = [super initWithImage:image];
    if (self) {
        
    }
    return self;
}
- (void)awakeFromNib{
    [self addTapGes];
}
- (void)addTapGes{
    self.userInteractionEnabled = YES;
    self.isSelected = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    [self addGestureRecognizer:tap];
    
}
- (void)tapGes:(UITapGestureRecognizer *)ges{
    self.isSelected = !self.isSelected;
    FinanceAnnalyzeTableViewCell *cell = self.superview.superview;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:cell,@"financeCell", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"isSelectednotice" object:nil userInfo:dic];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
