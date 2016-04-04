//
//  HomepageHeaderTableViewCell.m
//  ERVICE
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "HomepageHeaderTableViewCell.h"

@implementation HomepageHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)myExclusive:(UIButton *)sender {
    if (self.myExculsiveBlock) {
        self.myExculsiveBlock();
    }
}

- (IBAction)businessConsult:(UIButton *)sender {
    if (self.businessBlock) {
        self.businessBlock();
    }
}

- (IBAction)specailistConversation:(UIButton *)sender {
    if (self.specialistBlock) {
        self.specialistBlock();
    }
}

- (IBAction)famousExample:(UIButton *)sender {
    if (self.famousBolck) {
        self.famousBolck();
    }
}

@end
