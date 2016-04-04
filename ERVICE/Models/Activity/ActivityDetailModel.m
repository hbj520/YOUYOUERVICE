//
//  ActivityDetailModel.m
//  ERVICE
//
//  Created by apple on 3/29/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "ActivityDetailModel.h"

@implementation ActivityDetailModel
- (id)initWithTitle:(NSString *)title image:(NSString *)imageurl num:(NSString *)num innum:(NSString *)innum starttime:(NSString *)starttime endtime:(NSString *)endtime content:(NSString *)content {
    ActivityDetailModel *model = [[ActivityDetailModel alloc] init];
    model.title = title;
    model.imageUrl = imageurl;
    model.starttime = starttime;
    model.content = content;
    model.endtime = endtime;
    model.num = num;
    model.innum = innum;
    return model;
}
- (ActivityDetailModel *)buildWithData:(NSDictionary *)data{
    NSString *starttime = data[@"starttime"];
    NSString *content = data[@"content"];
    NSString *title = data[@"title"];
    NSString *imageurl = data[@"imgthumb"];
    NSString *innum = data[@"innum"];
    NSNumber *num = data[@"num"];
    NSString *numString = [NSString stringWithFormat:@"%ld",num.integerValue];
    NSString *endtime = data[@"endtime"];
    ActivityDetailModel *model = [[ActivityDetailModel alloc] initWithTitle:title image:imageurl num:numString innum:innum starttime:starttime endtime:endtime content:content];
    return model;
}
@end
