//
//  UserInfoModel.h
//  ERVICE
//
//  Created by apple on 3/28/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject
@property (nonatomic,strong) NSString *username;
@property (nonatomic,strong) NSString *phone;
@property (nonatomic,strong) NSString *uid;
@property (nonatomic,strong) NSString *token;
- (id)initWithParams:(NSString *)userName
               phone:(NSString *)phone
              userId:(NSString *)uid
               token:(NSString *)token;
- (UserInfoModel *)buildWithDatas:(NSDictionary *)datas;
@end