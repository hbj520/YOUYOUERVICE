//
//  TeacherCatigoryModel.m
//  ERVICE
//
//  Created by apple on 3/30/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "TeacherCatigoryModel.h"

@implementation TeacherCatigoryModel
- (id)initWithImage:(NSString *)imageurl title:(NSString *)title categoryId:(NSString *)categoryId{
    TeacherCatigoryModel *model = [[TeacherCatigoryModel alloc] init];
    model.image = imageurl;
    model.title = title;
    model.categoryId = categoryId;
    return model;
}
- (NSMutableArray *)buildWithCategoryData:(NSArray *)data{
    NSMutableArray *categoryArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *title = dic[@"ctgname"];
        NSString *imageurl = dic[@"imgthumb"];
        NSString *categoruId = dic[@"id"];
        TeacherCatigoryModel *catogory = [[TeacherCatigoryModel alloc] initWithImage:imageurl title:title categoryId:categoruId];
        [categoryArray addObject:catogory];
    }
    return categoryArray;
}
@end
