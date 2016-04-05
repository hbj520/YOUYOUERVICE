//
//  MyTeacherModel.m
//  ERVICE
//
//  Created by 陈 志徽 on 16/4/5.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "MyTeacherModel.h"

@implementation MyTeacherModel
- (id)initWithTechName:(NSString *)techName
                techId:(NSString *)techId
             techImage:(NSString *)techImage
             techStars:(NSString *)techStars
           techFansNum:(NSString *)techFansNum
            techSchool:(NSString *)techGratudeSchool
        techNewArticle:(NSString *)techNewArticle
         techArticleId:(NSString *)techArticleId{
    MyTeacherModel *model = [[MyTeacherModel alloc] init];
    model.techName = techName;
    model.techId = techId;
    model.techImage = techImage;
    model.techStars = techStars;
    model.techFansNum = techFansNum;
    model.techGratudeSchool = techGratudeSchool;
    model.techNewArticle = techNewArticle;
    model.techArticleId = model.techArticleId;
    return model;
}
- (NSMutableArray *)buildWithData:(NSArray *)data{
    NSMutableArray *techArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *name = dic[@"name"];
        NSString *userId = dic[@"userid"];
        NSString *img = dic[@"imgthumb"];
        NSString *star = dic[@"star"];
        NSString *fansnum = dic[@"num"];
        NSString *school = dic[@"school"];
        NSString *article = dic[@"article"];
        NSString *articleId = dic[@"articleid"];
        MyTeacherModel *model = [[MyTeacherModel alloc] initWithTechName:name
                                                                  techId:userId
                                                               techImage:img
                                                               techStars:star
                                                             techFansNum:fansnum
                                                              techSchool:school
                                                          techNewArticle:article techArticleId:articleId];
        [techArray addObject:model];
    }
    return techArray;
}
@end
