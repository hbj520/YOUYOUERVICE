//
//  HorizontalTableViewCell.h
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamousTechListModel;
@protocol HorizontalTableViewCellDelegate <NSObject>
- (void)TapColletionViewCellDelegate:(FamousTechListModel *)famousListModel indexPath:(NSIndexPath *)indexPath;
- (void)TapCollectionViewCellAttentionBtnDelegate:(FamousTechListModel *)famousListModel indexPath:(NSIndexPath *)indexPath;

@end
@interface HorizontalTableViewCell : UITableViewCell<
                                                     UICollectionViewDelegate,
                                                     UICollectionViewDataSource,
                                                     UICollectionViewDelegateFlowLayout
                                                    >
@property (nonatomic,strong) NSArray *modelsArray;
@property (nonatomic,assign) id<HorizontalTableViewCellDelegate> delegate;

@end
