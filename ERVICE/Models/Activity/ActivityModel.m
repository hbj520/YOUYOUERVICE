//
//  ActivityModel.m
//  ERVICE
//
//  Created by apple on 3/28/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "ActivityModel.h"

@implementation ActivityModel
- (id)initWithParameters:(NSString *)title content:(NSString *)content num:(NSString *)num starttime:(NSString *)startime endtime:(NSString *)endtime image:(NSString *)imageurl activityId:(NSString *)activityId{
    ActivityModel *acModel = [[ActivityModel alloc] init];
    acModel.title = title;
    acModel.content = content;
    acModel.num = num;
    acModel.starttime = startime;
    acModel.endtime = endtime;
    acModel.image = imageurl;
    acModel.activityId = activityId;
    return acModel;
}
- (NSMutableArray *)buildWithData:(NSArray *)data{
    NSMutableArray *activityArray = [NSMutableArray array];
        for (NSDictionary *dic in data) {
            NSNumber *num = dic[@"num"];
            NSString *numCount = [NSString stringWithFormat:@"%ld",num.integerValue];
            NSString *title = dic[@"title"];
            NSString *image = dic[@"imgthumb"];
            NSString *endtime = dic[@"endtime"];
            NSString *content = dic[@"content"];
            NSString *starttime = dic[@"starttime"];
            NSString *activityId = dic[@"activityid"];
            ActivityModel *model = [[ActivityModel alloc] initWithParameters:title content:content num:numCount starttime:starttime endtime:endtime image:image activityId:activityId];
            [activityArray addObject:model];
    }
       return activityArray;
}
@end
