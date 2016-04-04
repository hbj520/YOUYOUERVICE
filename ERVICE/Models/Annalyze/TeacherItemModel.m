//
//  TeacherItemModel.m
//  ERVICE
//
//  Created by apple on 3/21/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "TeacherItemModel.h"

@implementation TeacherItemModel
- (id)initWithImge:(NSString *)image title:(NSString *)title content:(NSString *)content itemId:(NSString *)itemId{
    TeacherItemModel *model = [[TeacherItemModel alloc] init];
    model.image = image;
    model.title = title;
    model.content = content;
    model.itemId = itemId;
    return model;
}
-(NSMutableArray *)builderWithMenus:(NSArray *)menus{
    NSMutableArray *array = [NSMutableArray array];
    for (NSDictionary *dict in menus) {
        NSString *itemId = dict[@"id"];
        NSString *title = dict[@"title"];
        NSString *image = dict[@"imgthumb"];
        NSString *content = dict[@"about"];
        TeacherItemModel *model = [[TeacherItemModel alloc] initWithImge:image title:title content:content itemId:itemId];
        [array addObject:model];
    }
    return array;
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
@end
