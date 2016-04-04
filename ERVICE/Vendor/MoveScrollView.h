//
//  MoveScrollView.h
//  MoveGridView
//
//  Created by apple on 3/18/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//  可移动格子scrollview

#import <UIKit/UIKit.h>
#import "CustomGrid.h"
typedef void (^GridItemClickBlock)(CustomGrid *);
@interface MoveScrollView : UIScrollView<CustomGridDelegate>
@property (nonatomic,strong) NSMutableArray *showGridArray;//标题
@property (nonatomic,strong) NSMutableArray *normalImgArr;//正常的图片
@property (nonatomic,strong) NSMutableArray *highlightImgArr;//选中后的图片数组
@property (nonatomic,strong) UIImage *deleteImage;//删除icon
@property (nonatomic,strong) NSMutableArray *gridListArray;
@property (nonatomic,strong) NSMutableArray *addGridArray;
//点击格子
@property (nonatomic,copy) GridItemClickBlock gridClickBlock;
//点击啊删除格子按钮
@property (nonatomic,copy) GridItemClickBlock deleteGridBlock;
- (instancetype)initwithFrame:(CGRect )frame ;
- (void)drawGridIsShowTitle:(BOOL)isshowTitle withGridFrame:(CGRect)frame;
@end
