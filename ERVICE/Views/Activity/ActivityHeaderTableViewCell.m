//
//  ActivityHeaderTableViewCell.m
//  ERVICE
//
//  Created by apple on 3/22/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "ActivityHeaderTableViewCell.h"
@interface ActivityHeaderTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *smallImage;
@property (weak, nonatomic) IBOutlet UILabel *reminderLabel;
@end
@implementation ActivityHeaderTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //[self setTranslatesAutoresizingMaskIntoConstraints:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithsmallImage:(NSString *)smallImage reminder:(NSString *)reminderText{
    self.smallImage.image = [UIImage imageNamed:smallImage];
    self.reminderLabel.text = reminderText;
}
@end
