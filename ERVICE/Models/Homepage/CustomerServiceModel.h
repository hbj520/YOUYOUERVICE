//
//  CustomerServiceModel.h
//  ERVICE
//
//  Created by youyou on 16/4/7.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CustomerServiceModel : NSObject
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString *phone;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *imageurl;
@property (nonatomic,copy) NSString *realname;
@property (nonatomic,copy) NSString *star;

- (id)initWithParameters:(NSString *)username
                   phone:(NSString *)phone
                  userid:(NSString *)userid
                imageurl:(NSString *)imageurl
                realname:(NSString *)realname
                    star:(NSString *)star;

- (NSMutableArray *)buildWithData:(NSArray *)data;
@end
