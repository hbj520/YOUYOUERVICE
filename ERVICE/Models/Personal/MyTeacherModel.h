//
//  MyTeacherModel.h
//  ERVICE
//
//  Created by 陈 志徽 on 16/4/5.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTeacherModel : NSObject
@property (nonatomic,copy) NSString *techName;
@property (nonatomic,copy) NSString *techId;
@property (nonatomic,copy) NSString *techImage;
@property (nonatomic,copy) NSString *techStars;
@property (nonatomic,copy) NSString *techFansNum;
@property (nonatomic,copy) NSString *techGratudeSchool;
@property (nonatomic,copy) NSString *techNewArticle;
@property (nonatomic,copy) NSString *techArticleId;
- (id)initWithTechName:(NSString *)techName
                techId:(NSString *)techId
             techImage:(NSString *)techImage
             techStars:(NSString *)techStars
           techFansNum:(NSString *)techFansNum
            techSchool:(NSString *)techGratudeSchool
        techNewArticle:(NSString *)techNewArticle
         techArticleId:(NSString *)techArticleId;
- (NSMutableArray *)buildWithData:(NSArray *)data;
@end
