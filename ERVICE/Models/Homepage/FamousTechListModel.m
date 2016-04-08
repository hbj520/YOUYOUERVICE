//
//  FamousTechListModel.m
//  ERVICE
//
//  Created by youyou on 16/4/6.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "FamousTechListModel.h"

@implementation FamousTechListModel
- (id)initWithTechName:(NSString *)techName
               techDes:(NSString *)techDes
                techId:(NSString *)techId
             techStars:(NSString *)techStars
            techExName:(NSString *)techExName
             techImage:(NSString *)techImage
               fansNum:(NSString *)fansNum
           isAttention:(BOOL )isAttention{
    FamousTechListModel *model = [[FamousTechListModel alloc] init];
    model.techName = techName;
    model.techDes = techDes;
    model.techId = techId;
    model.techStars = techStars;
    model.techExName = techExName;
    model.techImage = techImage;
    model.fansNum = fansNum;
    model.istechAttention = isAttention;
    return model;
}

- (NSMutableArray *)buildData:(NSArray *)data{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *techName = dic[@"username"];
        NSString *techDes = dic[@"description"];
        NSString *techId = dic[@"tid"];
        NSString *techStars = dic[@"star"];
        NSString *techExName = dic[@"ex_name"];
        //NSNumber *fansNum = dic[@"num"];
        NSString *fansNumbers = dic[@"num"];
        NSString *image = dic[@"imgthumb"];
        NSNumber *isattention = dic[@"ifattention"];
        BOOL isAttenTech = isattention.boolValue;
        FamousTechListModel *model = [[FamousTechListModel alloc] initWithTechName:techName
                                                                           techDes:techDes
                                                                            techId:techId
                                                                         techStars:techStars
                                                                        techExName:techExName
                                                                         techImage:image
                                                                           fansNum:fansNumbers
                                                                       isAttention:isAttenTech];
        [modelArray addObject:model];
    }
    return modelArray;
}
@end
