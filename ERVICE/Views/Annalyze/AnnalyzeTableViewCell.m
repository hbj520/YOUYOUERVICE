//
//  AnnalyzeTableViewCell.m
//  ERVICE
//
//  Created by apple on 3/21/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "AnnalyzeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "TeacherItemModel.h"
@interface AnnalyzeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageview;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@end
@implementation AnnalyzeTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithdata:(TeacherItemModel *)data{
    [self.headerImageview sd_setImageWithURL:[NSURL URLWithString:data.image] placeholderImage:[UIImage imageNamed:@"default"]];
    self.titleLabel.text = data.title;
    self.contentLabel.text = data.content;
}
@end
