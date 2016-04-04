//
//  ThreeCollectionViewCell.h
//  ERVICE
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomepageExchangeModel;
@interface ThreeCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
@property (strong, nonatomic) IBOutlet UILabel *titleLable;
- (void)configWithData:(HomepageExchangeModel *)exchangeModel;
@end
