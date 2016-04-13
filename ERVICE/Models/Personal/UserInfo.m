//
//  UserInfo.m
//  ERVICE
//
//  Created by youyou on 16/4/12.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo
- (id)initWithUserName:(NSString *)username
                 email:(NSString *)email
                 qqNum:(NSString *)qqNum
                  name:(NSString *)name
                   sex:(NSString *)sex{
    UserInfo *userInfo = [[UserInfo alloc] init];
    userInfo.userName = username;
    userInfo.email = email;
    userInfo.qqNum = qqNum;
    userInfo.name = name;
    userInfo.sex = sex;
    return userInfo;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.userName = [aDecoder decodeObjectForKey:@"username"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.qqNum = [aDecoder decodeObjectForKey:@"qq"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
        self.sex = [aDecoder decodeObjectForKey:@"sex"];
        
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.userName forKey:@"username"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.qqNum forKey:@"qq"];
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.sex forKey:@"sex"];
}
- (UserInfo *)buidWithData:(NSDictionary *)data{
    NSString *username = data[@"username"];
    NSString *name = data[@"name"];
    NSString *email = data[@"email"];
    NSString *qq = data[@"qq"];
    NSString *sex = data[@"sex"];
    UserInfo *userinfo = [[UserInfo alloc] initWithUserName:username
                                                      email:email
                                                      qqNum:qq
                                                       name:name
                                                        sex:sex];
    return userinfo;
}
+ (void)saveUserInfo:(UserInfo *)userInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"userinfo"];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:userInfo];
    [defaults setObject:data forKey:@"userinfo"];
    [defaults synchronize];
}
+ (id)getUserInfo{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [defaults objectForKey:@"userinfo"];
    UserInfo *userinfo = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    return userinfo;
}
@end
