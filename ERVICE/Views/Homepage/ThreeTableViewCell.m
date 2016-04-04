//
//  ThreeTableViewCell.m
//  ERVICE
//
//  Created by apple on 16/3/15.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "ThreeTableViewCell.h"
#import "ThreeCollectionViewCell.h"
#import "Tools.h"
#include "Marco.h"
#import "HomepageExchangeModel.h"
static NSString *cellReuseId = @"cellId";
@interface ThreeTableViewCell()
{
    UICollectionView *_collectionView;
}
@end
@implementation ThreeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifie{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifie];
    if (self) {
        [self initContentView];//初始化
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark - PrivateMethod
- (void)initContentView{
    //self.backgroundColor = [UIColor redColor];
    //初始化自定义的layout
    UICollectionViewFlowLayout * _flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _flowLayout.minimumInteritemSpacing = 0;
    _flowLayout.minimumLineSpacing = 0;
    _flowLayout.itemSize = CGSizeMake((ScreenWidth - 50)/3, 130);
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 130) collectionViewLayout:_flowLayout];
    //注册cell
    UINib *cellNib = [UINib nibWithNibName:@"ThreeCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:cellNib forCellWithReuseIdentifier:cellReuseId];
    
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    _collectionView.bounces = NO;
    _collectionView.scrollEnabled = YES;
    _collectionView.showsVerticalScrollIndicator = NO; //指士条
    _collectionView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_collectionView];
    
}

#pragma mark - UICollectionViewDelegate
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelsArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //重用cell
    ThreeCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:cellReuseId forIndexPath:indexPath];

    HomepageExchangeModel *exchangeModel = [self.modelsArray objectAtIndex:indexPath.item];
    [cell configWithData:exchangeModel];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{    
    if (self.delegate) {
        [self.delegate TapCollectionViewCellDelegate:nil tapIndexPath:indexPath];
    }
    NSLog(@"cc:%ld--%ld",(long)indexPath.section,indexPath.item);
}

@end
