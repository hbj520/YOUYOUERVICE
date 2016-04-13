//
//  UserInfo.h
//  ERVICE
//
//  Created by youyou on 16/4/12.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject<NSCoding>
@property (nonatomic,strong) NSString *userName;
@property (nonatomic,strong) NSString *email;
@property (nonatomic,strong) NSString *qqNum;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *sex;
- (id)initWithUserName:(NSString *)username
                 email:(NSString *)email
                 qqNum:(NSString *)qqNum
                  name:(NSString *)name
                   sex:(NSString *)sex;
- (UserInfo *)buidWithData:(NSDictionary *)data;
+ (void)saveUserInfo:(UserInfo *)userInfo;
+ (id)getUserInfo;
@end
