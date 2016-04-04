//
//  UserInfoModel.m
//  ERVICE
//
//  Created by apple on 3/28/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel
- (id)initWithParams:(NSString *)userName phone:(NSString *)phone userId:(NSString *)uid token:(NSString *)token{
    UserInfoModel *userInfo = [[UserInfoModel alloc] init];
    userInfo.username = userName;
    userInfo.phone = phone;
    userInfo.uid = uid;
    userInfo.token = token;
    return userInfo;
}
- (UserInfoModel *)buildWithDatas:(NSDictionary *)datas{
    NSString *name = [datas objectForKey:@"username"];
    NSString *phone = [datas objectForKey:@"phone"];
    NSString *userid = [datas objectForKey:@"uid"];
    NSString *token = [datas objectForKey:@"token"];
    UserInfoModel *userInfo = [[UserInfoModel alloc] initWithParams:name phone:phone userId:userid token:token];
    
    return userInfo;
}
@end
