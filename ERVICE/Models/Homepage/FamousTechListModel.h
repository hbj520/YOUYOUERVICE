//
//  FamousTechListModel.h
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamousTechListModel : NSObject
@property (nonatomic,strong) NSString *techName;
@property (nonatomic,strong) NSString *techDes;
@property (nonatomic,strong) NSString *techId;
@property (nonatomic,strong) NSString *techStars;
@property (nonatomic,strong) NSString *techExName;
@property (nonatomic,strong) NSString *techImage;
@property (nonatomic,strong) NSString *fansNum;
@property (assign,nonatomic) BOOL istechAttention;
- (id)initWithTechName:(NSString *)techName
               techDes:(NSString *)techDes
                techId:(NSString *)techId
             techStars:(NSString *)techStars
            techExName:(NSString *)techExName
             techImage:(NSString *)techImage
               fansNum:(NSString *)fansNum
           isAttention:(BOOL )isAttention;

- (NSMutableArray *)buildData:(NSArray *)data;

@end
