//
//  FamousTechListModel.h
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamousTechListModel : NSObject
@property (nonatomic,copy) NSString *techName;
@property (nonatomic,copy) NSString *techDes;
@property (nonatomic,copy) NSString *techId;
@property (nonatomic,copy) NSString *techStars;
@property (nonatomic,copy) NSString *techExName;
@property (nonatomic,copy) NSString *techImage;
@property (nonatomic,assign) BOOL *techAttention;
- (id)initWithTechName:(NSString *)techName
               techDes:(NSString *)techDes
                techId:(NSString *)techId
             techStars:(NSString *)techStars
            techExName:(NSString *)techExName
             techImage:(NSString *)techImage;

- (NSMutableArray *)buildData:(NSArray *)data;

@end
