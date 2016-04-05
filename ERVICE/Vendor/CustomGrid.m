//
//  CustomGrid.m
//  MoveGrid
//
//  Created by Jerry.li on 14-11-6.
//  Copyright (c) 2014年 51app. All rights reserved.
//

#import "CustomGrid.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation CustomGrid

@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

//创建格子
- (id)initWithFrame:(CGRect)frame
              title:(NSString *)title
        normalImage:(NSString *)normalImage
   highlightedImage:(NSString *)highlightedImage
             gridId:(NSInteger)gridId
            atIndex:(NSInteger)index
        isAddDelete:(BOOL)isAddDelete
         deleteIcon:(UIImage *)deleteIcon
        isShowTitle:(BOOL)isShowTitle
{
    self = [super initWithFrame:frame];
    if (self) {
        
            //计算每个格子的X坐标
        CGFloat pointX = index * (GridWidth + PaddingX) + PaddingX;;
        //计算每个格子的Y坐标
        CGFloat pointY =  PaddingY;
      //  NSLog(@"with %f height %f",GridWidth,GridHeight);
        [self setFrame:CGRectMake(pointX, pointY, frame.size.width, frame.size.height)];
    //    self.backgroundColor = [UIColor redColor];
        UIImageView *imageView = [[UIImageView alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesTap:)];
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:tap];
        //下载图片
        [imageView sd_setImageWithURL:[NSURL URLWithString:normalImage] placeholderImage:[UIImage imageNamed:@"default"]];
        imageView.frame = CGRectMake(GridWidth/6, GridWidth/6, GridWidth/2, GridWidth/2);
        if (isShowTitle) {
            UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(GridWidth/4, 2*GridWidth/3, GridWidth/2, GridWidth/4)];
            titleLabel.font = [UIFont boldSystemFontOfSize:14];
            titleLabel.text = title;
            titleLabel.textColor = [UIColor lightGrayColor];
            titleLabel.textAlignment = UITextAlignmentLeft;
            [self addSubview:titleLabel];
        }
        [self addSubview:imageView];
//        [self setTitle:title forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
//        [self setBackgroundImage:nil forState:UIControlStateNormal];
//        [self setBackgroundImage:nil forState:UIControlStateHighlighted];
//        self.titleLabel.font = [UIFont boldSystemFontOfSize:14];
        [self addTarget:self action:@selector(gridClick:) forControlEvents:UIControlEventTouchUpInside];
        
        //////////
        [self setGridId:gridId];
        [self setGridIndex:index];
        [self setGridCenterPoint:self.center];
        
        //判断是否要添加删除图标
        if (isAddDelete) {
            //当长按时添加删除按钮图标
            UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            [deleteBtn setFrame:CGRectMake(55, 10, 16, 16)];
            [deleteBtn setBackgroundColor:[UIColor clearColor]];
            [deleteBtn setBackgroundImage:deleteIcon forState:UIControlStateNormal];
            [deleteBtn addTarget:self action:@selector(deleteGrid:) forControlEvents:UIControlEventTouchUpInside];
            [deleteBtn setHidden:YES];
            
            /////////////
            [deleteBtn setTag:gridId];
            [self addSubview:deleteBtn];
            
            //添加长按手势
            UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(gridLongPress:)];
            [self addGestureRecognizer:longPressGesture];
             longPressGesture = nil;
        }
    }
    return self;
}


//响应格子点击事件
- (void)tapGesTap:(id)sender{
    
    [self.delegate gridItemDidClicked:self];
}
- (void)gridClick:(CustomGrid *)clickItem
{
    
    
    [self.delegate gridItemDidClicked:clickItem];
}

//响应格子删除事件
- (void)deleteGrid:(UIButton *)deleteButton
{
    [self.delegate gridItemDidDeleteClicked:deleteButton];
}

//响应格子的长安手势事件
- (void)gridLongPress:(UILongPressGestureRecognizer *)longPressGesture
{
    switch (longPressGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            [self.delegate pressGestureStateBegan:longPressGesture withGridItem:self];
            break;
        }
        case UIGestureRecognizerStateChanged:
        {
            //应用移动后的新坐标
            CGPoint newPoint = [longPressGesture locationInView:longPressGesture.view];
            [self.delegate pressGestureStateChangedWithPoint:newPoint gridItem:self];
            break;
        }
        case UIGestureRecognizerStateEnded:
        {
            [self.delegate pressGestureStateEnded:self];
            break;
        }
        default:
            break;
    }
}

//根据格子的坐标计算格子的索引位置
+ (NSInteger)indexOfPoint:(CGPoint)point
               withButton:(UIButton *)btn
                gridArray:(NSMutableArray *)gridListArray
{
    for (NSInteger i = 0;i< gridListArray.count;i++)
    {
        UIButton *appButton = gridListArray[i];
        if (appButton != btn)
        {
            if (CGRectContainsPoint(appButton.frame, point))
            {
                return i;
            }
        }
    }
    return -1;
}

@end
