//
//  HorizontalTableViewCell.m
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "HorizontalTableViewCell.h"

#import "TeacherListCollectionViewCell.h"

static NSString *techListReuseId = @"techlistId";
@interface HorizontalTableViewCell()
{
    UICollectionView *_collectionView;
}
@end
@implementation HorizontalTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCollectionView];//初始化
    }
    return self;
}
#pragma mark - PrivateMethod
- (void)initCollectionView{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.itemSize = CGSizeMake(120, 170);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;//设置为横向滑动方向
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 170) collectionViewLayout:flowLayout];
    //注册collectionviewcell
    UINib *nib = [UINib nibWithNibName:@"TeacherListCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nib forCellWithReuseIdentifier:techListReuseId];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = YES;
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.showsVerticalScrollIndicator = NO; //指士条
    _collectionView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_collectionView];
}
#pragma mark - UICollectionViewCellDelegate
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    TeacherListCollectionViewCell *cell = [_collectionView dequeueReusableCellWithReuseIdentifier:techListReuseId forIndexPath:indexPath];
    FamousTechListModel *model = [self.modelsArray objectAtIndex:indexPath.row];
    [cell configWithData:model];
    cell.attentionBlock = ^(id sender){
        UIButton *attentionBtn = (UIButton *)sender;
        if (self.delegate) {
            [self.delegate TapCollectionViewCellAttentionBtnDelegate:attentionBtn indexPath:indexPath];
        }
    };
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.modelsArray.count;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.delegate) {
        FamousTechListModel *model = [self.modelsArray objectAtIndex:indexPath.row];
        [self.delegate TapColletionViewCellDelegate:model indexPath:indexPath];
    }
}
@end
