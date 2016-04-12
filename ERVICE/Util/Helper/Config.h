//
//  Config.h
//  ERVICE
//
//  Created by apple on 3/31/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Config : NSObject
+ (Config *)Instance;
+(id)allocWithZone:(NSZone *)zone;

//保存用户userid 用户name 用户phone token
- (void)saveUserid:(NSString *)userid
          userName:(NSString *)username
      userPhoneNum:(NSString *)PhoneNum
             token:(NSString *)token
              icon:(NSString *)icon;
//保存头像url
- (void)saveIcon:(NSString *)icon;
//获取本地保存的用户userid 用户name 用户phone token
- (NSString *)getUserid;
- (NSString *)getUserName;
- (NSString *)getUserPhoneNum;
- (NSString *)getToken;
- (NSString *)getUserIcon;   
//退出登录
- (void)logOut;

//
@end
