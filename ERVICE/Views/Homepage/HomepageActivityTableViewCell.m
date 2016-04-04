//
//  HomepageActivityTableViewCell.m
//  ERVICE
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "HomepageActivityTableViewCell.h"
@interface HomepageActivityTableViewCell()

@end
@implementation HomepageActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
     
    // Configure the view for the selected state
}

- (IBAction)rookieBtn:(UIButton *)sender {
    if (self.rookieBlock) {
        self.rookieBlock();
    }
}

- (IBAction)newActivityBtn:(UIButton *)sender {
    if (self.newActivityBlock) {
        self.newActivityBlock();
    }
}
@end
