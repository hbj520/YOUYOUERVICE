//
//  ThreeTableViewCell.h
//  ERVICE
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HomepageAnalyzeModel;
@protocol HomepageTabelViewCellDelegate <NSObject>

- (void)TapCollectionViewCellDelegate:(HomepageAnalyzeModel *)analyzeModel tapIndexPath:(NSIndexPath *)indexPath;

@end
@interface ThreeTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) NSArray *modelsArray;
@property (nonatomic,assign) id<HomepageTabelViewCellDelegate> delegate;

@end
