//
//  CustomerServiceModel.m
//  ERVICE
//
//  Created by youyou on 16/4/7.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "CustomerServiceModel.h"

@implementation CustomerServiceModel
- (id)initWithParameters:(NSString *)username
                   phone:(NSString *)phone
                  userid:(NSString *)userid
                imageurl:(NSString *)imageurl
                realname:(NSString *)realname
                    star:(NSString *)star{
    CustomerServiceModel *model = [[CustomerServiceModel alloc] init];
    model.username = username;
    model.phone = phone;
    model.userid = userid;
    model.imageurl = imageurl;
    model.realname = realname;
    model.star = model.star;
    return model;
}

- (NSMutableArray *)buildWithData:(NSArray *)data{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *username = dic[@"username"];
        NSString *phone = dic[@"phone"];
        NSString *userid = dic[@"userid"];
        NSString *imageurl = dic[@"imgthumb"];
        NSString *realname = dic[@"name"];
        NSString *star = dic[@"star"];
        CustomerServiceModel *model = [[CustomerServiceModel alloc] initWithParameters:username
                                                                                 phone:phone
                                                                                userid:userid
                                                                              imageurl:imageurl
                                                                              realname:realname
                                                                                  star:star];
        [modelArray addObject:model];
    }
    return modelArray;
}
@end
