//
//  LecturerModel.m
//  ERVICE
//
//  Created by apple on 3/28/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "LecturerModel.h"

@implementation LecturerModel
- (id)initWithParameters:(NSString *)userName
                  lecDes:(NSString *)lecDes
                  userid:(NSString *)userid
                    star:(NSString *)star
                  exname:(NSString *)exname
                     num:(NSString *)num
             lectureIcon:(NSString *)lectureIcon
             isAttention:(BOOL)isAttention{
    LecturerModel *model = [[LecturerModel alloc] init];
    model.userid = userid;
    model.username = userName;
    model.lecDescription = lecDes;
    model.star = star;
    model.exname = exname;
    model.num = num;
    model.lecturerIcon = lectureIcon;
    model.isAttention = isAttention;
    return model;
}
- (NSMutableArray *)buildWithData:(NSArray *)data{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *userid = dic[@"userid"];
        NSString *starLevel = dic[@"star"];
        NSString *username = dic[@"username"];
        NSString *image = dic[@"imgthumb"];
        NSString *des = dic[@"description"];
        NSNumber *num = dic[@"num"];
        NSString *numCount = [NSString stringWithFormat:@"%ld",num.integerValue];
        NSString *exname = dic[@"ex_name"];
        NSNumber *isAttention = dic[@"ifattention"];
        BOOL isAtten = isAttention.boolValue;
        LecturerModel *lecModel = [[LecturerModel alloc] initWithParameters:username lecDes:des userid:userid star:starLevel exname:exname num:numCount lectureIcon:image isAttention:isAtten];
        [modelArray addObject:lecModel];
    }
   return modelArray;
}

@end
