//
//  AnnounceContentTableViewCell.m
//  ERVICE
//
//  Created by apple on 3/24/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "AnnounceContentTableViewCell.h"

#import "AnnoucementModel.h"
@interface AnnounceContentTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIView *ishotView;


@end
@implementation AnnounceContentTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)configWithData:(AnnoucementModel *)model{
    self.titleLabel.text = model.articleTitle;
}
@end
