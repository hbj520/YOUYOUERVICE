//
//  MoveScrollView.m
//  MoveGridView
//
//  Created by apple on 3/18/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "MoveScrollView.h"
#import "CustomGrid.h"
@interface MoveScrollView ()
{
    BOOL isSelected;
    BOOL contain;
    //是否可跳转应用对应的详细页面
    BOOL isSkip;
    
    //选中格子的起始位置
    CGPoint startPoint;
    //选中格子的起始坐标位置
    CGPoint originPoint;
}
@end
@implementation MoveScrollView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
    }
    
    return self;
}
#pragma mark - PrivateMethod
- (void)initData{
    if (!self.gridListArray) {
        self.gridListArray = [NSMutableArray array];
    }else{
        [self.gridListArray removeAllObjects];
    }
    isSelected = NO;
    self.scrollEnabled = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.showsVerticalScrollIndicator = NO;
    if (self.addGridArray.count > 0) {
        for (NSInteger i = 0; i < self.addGridArray.count; i++) {
            NSInteger count = self.showGridArray.count - 1;
            [self.showGridArray insertObject:self.addGridArray[i] atIndex:count];
        }
    }
    
    for (NSInteger i = 0; i < self.showGridArray.count; i++) {
        NSString *gridId = self.showGridArray[i];
        NSLog(@"new add grid is gridId: %@", gridId);
    }

}
- (void)drawGridIsShowTitle:(BOOL)isshowTitle withGridFrame:(CGRect)frame{
    int column;
    int count = (int)self.showGridArray.count;
    if (count % 4 == 0) {
        column = count / 4;
    }else{
        column = count/4 + 1;
    }
    self.contentSize = CGSizeMake(ScreenWidth *column,GridHeight );
    [self setBackgroundColor:[UIColor whiteColor]];
    for (NSInteger index = 0; index < [self.showGridArray count]; index++) {
        NSString *gridTitle = self.showGridArray[index];
        BOOL isAddDelete = YES;
        if ([gridTitle isEqualToString:@"0"]) {
            isAddDelete = NO;
        }
        NSString *normalImg = self.normalImgArr[index];
        NSString *highlightImage = self.normalImgArr[index];
        
        CustomGrid *gridItem = [[CustomGrid alloc] initWithFrame:frame title:gridTitle normalImage:normalImg highlightedImage:highlightImage gridId:[gridTitle integerValue] atIndex:index isAddDelete:isAddDelete deleteIcon:self.deleteImage isShowTitle:isshowTitle];
        gridItem.delegate = self;
        [self addSubview:gridItem];
        [self.gridListArray addObject:gridItem];
    }
}
#pragma  mark -CustomGrid Delegate
//响应格子的点击事件
- (void)gridItemDidClicked:(CustomGrid *)clickItem{
    isSkip = YES;
    //查看是否有选中的格子，并且比较点击的格子是否就是选中的格子
    for (NSInteger i = 0; i < [self.gridListArray count]; i++) {
        CustomGrid *item = self.gridListArray[i];
        if (item.isChecked || item.gridId != clickItem.gridId) {
            item.isChecked = NO;
            item.isMove = NO;
            isSelected = NO;
            isSkip = NO;
            // 隐藏删除图标
            UIButton *removeBtn = (UIButton *)[self viewWithTag:item.gridId];
            removeBtn.hidden = YES;
            if (clickItem.gridId == 0) {
                isSkip = YES;
            }
            break;
        }
//        if (clickItem.state == UIControlStateHighlighted) {
//            clickItem setImage:(nullable UIImage *) forState:(UIControlState)
//        }
    }
    if (self.gridClickBlock) {
        self.gridClickBlock(clickItem);
    }
}
//响应点击格子删除事件
- (void)gridItemDidDeleteClicked:(UIButton *)deleteButton{
    for (NSInteger i = 0; i < self.gridListArray.count; i++) {
        CustomGrid *removeGrid = _gridListArray[i];
        if (removeGrid.gridId == deleteButton.tag) {
            [removeGrid removeFromSuperview];
            NSInteger count = self.gridListArray.count - 1;
            for (NSInteger index = removeGrid.gridIndex; index < count; index++) {
                CustomGrid *preGrid = self.gridListArray[index];
                CustomGrid *nextGrid = self.gridListArray[index + 1];
                [UIView animateWithDuration:0.5 animations:^{
                    nextGrid.center = preGrid.gridCenterPoint;
                }];
                nextGrid.gridIndex = index;
            }
            [self.gridListArray removeObjectAtIndex:removeGrid.gridIndex];
            NSString *gridID = [NSString stringWithFormat:@"%ld",removeGrid.gridId];
            //删除的应用添加到更多的应用数组
            [self.showGridArray removeObject:gridID];
            
        }
    }
}
- (void)pressGestureStateBegan:(UILongPressGestureRecognizer *)longPressGesture withGridItem:(CustomGrid *)grid{
    //判断格子是否已经被选中并且是否可移动状态，如果选中就加一个放大的特效
    if (isSelected && grid.isChecked) {
        grid.transform = CGAffineTransformMakeScale(1.2, 1.2);
    }
    NSInteger gridId = grid.gridId;
    //没有一个格子选中的时候
    if (!isSelected) {
        NSLog(@"没有一个格子选中.......");
        grid.isChecked = YES;
        grid.isMove = YES;
        isSelected = YES;
        
        //选中格子的时候显示删除图标
        UIButton *removeBtn = (UIButton *)[longPressGesture.view viewWithTag:grid.gridId];
        removeBtn.hidden = NO;
        
        //获取移动格子的起始位置
        startPoint = [longPressGesture locationInView:longPressGesture.view];
        //获取移动格子的起始位置中心点
        originPoint = grid.center;
        UIImage *higlightImg = [UIImage imageNamed:self.normalImgArr[gridId - 100]];
        // 给选中的格子添加放大的特效
        [UIView animateWithDuration:0.5 animations:^{
            grid.transform = CGAffineTransformMakeScale(1.2, 1.2);
            grid.alpha = 0.8;
        [grid setBackgroundImage:higlightImg forState:UIControlStateNormal];
        }];
    }
}
- (void)pressGestureStateChangedWithPoint:(CGPoint)gridPoint gridItem:(CustomGrid *)gridItem{
    if (isSelected && gridItem.isChecked) {
        NSLog(@"UIGestureRecognizerStateChanged.........");
        [self bringSubviewToFront:gridItem];
        //应用移动后的x坐标
        CGFloat deltaX = gridPoint.x -startPoint.x;
        //应用移动后的y坐标
        CGFloat deltaY = gridPoint.y - startPoint.y;
        //拖动的应用跟手势移动
        gridItem.center = CGPointMake(gridItem.center.x + deltaX, gridItem.center.y + deltaY);
        
        //移动的格子索引下标
        NSInteger fromIndex = gridItem.gridIndex;
        //移动到目标格子的索引下标
        NSInteger toIndex = [CustomGrid indexOfPoint:gridItem.center withButton:gridItem gridArray:self.gridListArray];
        NSInteger borderIndex = [self.showGridArray indexOfObject:@"0"];
        NSLog(@"borderIndex: %ld",borderIndex);
        if (toIndex < 0 || toIndex >= borderIndex ) {
            contain = NO;
        }else{
            // 获取移动到目标格子
            CustomGrid *targetGrid = self.gridListArray[toIndex];
            gridItem.center = targetGrid.gridCenterPoint;
            originPoint = targetGrid.gridCenterPoint;
            gridItem.gridIndex = toIndex;
            
            //判断格子的移动方向，是从后往前还是从前往后拖动
            if ((fromIndex - toIndex) > 0) {
                NSLog(@"从后往前拖动格子......");
                //从移动格子的位置开始，始终获取最后一个格子的索引位置
                NSInteger lastGridIndex = fromIndex;
                for (NSInteger i = toIndex; i < fromIndex; i++){
                    CustomGrid *lastGrid = self.gridListArray[lastGridIndex];
                    CustomGrid *preGrid = self.gridListArray[lastGridIndex - 1];
                   [UIView animateWithDuration:0.5 animations:^{
                       preGrid.center = lastGrid.gridCenterPoint;
                   }];
                    //实时更新格子的索引下标
                    preGrid.gridIndex = lastGridIndex;
                    lastGridIndex--;
                }
                //排列格子顺序和更新格子坐标信息
                [self sortGridList];
            }else if ((fromIndex - toIndex) < 0){
                //从前往后拖动格子
                NSLog(@"从前往后拖动格子......");
                //从移动格子到目标格子之间的所有歌子向前移动一格子
                for (NSInteger i = fromIndex; i < toIndex; i++) {
                    CustomGrid *topOneGrid = self.gridListArray[i];
                    CustomGrid *nextGrid = self.gridListArray[i + 1];
                    [UIView animateWithDuration:0.5 animations:^{
                        nextGrid.center = topOneGrid.gridCenterPoint;
                    }];
                    //实时更新格子的索引下标
                    nextGrid.gridIndex = i;
                }
                //排列格子顺序和更新格子坐标信息
                [self sortGridList];
            }
        }
    }
}
//格子移动结束时
- (void)pressGestureStateEnded:(CustomGrid *)gridItem{
    NSLog(@"uiesturerecognizerstateended.....");
    if (isSelected && gridItem.isChecked) {
        //撤销格子地放大特效
        [UIView animateWithDuration:0.5 animations:^{
            gridItem.transform = CGAffineTransformIdentity;
            gridItem.alpha = 1.0;
            if (!contain) {
                gridItem.center = originPoint;
            }
        }];
        //排列格子顺序和更新格子坐标信息
        [self sortGridList];
    }
}
- (void)sortGridList{
    //重新排列数组中存放的格子顺序
    [self.gridListArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        CustomGrid *tempGrid1 = (CustomGrid *)obj1;
        CustomGrid *tempGrid2 = (CustomGrid *)obj2;
        return tempGrid1.gridIndex > tempGrid2.gridIndex;
    }];
    //更新所有格子的中心点坐标信息
    for (NSInteger i = 0; i < self.gridListArray.count; i++) {
        CustomGrid *gridItem = self.gridListArray[i];
        gridItem.gridCenterPoint = gridItem.center;
    }
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    isSelected = NO;
    // Drawing code
}


@end
