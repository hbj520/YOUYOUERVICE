//
//  AnnounceTitleView.m
//  ERVICE
//
//  Created by apple on 3/24/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "AnnounceTitleView.h"
#import "AnnounceExchangeModel.h"
@interface AnnounceTitleView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;



@end
@implementation AnnounceTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)configWithData:(AnnounceExchangeModel *)data{
    self.titleLabel.text = data.exchangName;
}

@end
