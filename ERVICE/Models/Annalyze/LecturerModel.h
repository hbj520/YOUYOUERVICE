//
//  LecturerModel.h
//  ERVICE
//
//  Created by apple on 3/28/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//  讲师类model

#import <Foundation/Foundation.h>

@interface LecturerModel : NSObject
@property (nonatomic,strong) NSString *username;//讲师姓名
@property (nonatomic,strong) NSString *lecDescription;//讲师简介
@property (nonatomic,strong) NSString *userid;//讲师id
@property (nonatomic,strong) NSString *star;//讲师星级
@property (nonatomic,strong) NSString *exname;//交易所名称
@property (nonatomic,strong) NSString *num;//粉丝数量
@property (nonatomic,strong) NSString *lecturerIcon;//讲师头像
@property (nonatomic,assign) BOOL *isAttention;
- (id)initWithParameters:(NSString *)userName
                  lecDes:(NSString *)lecDes
                  userid:(NSString *)userid
                    star:(NSString *)star
                  exname:(NSString *)exname
                     num:(NSString *)num
             lectureIcon:(NSString *)lectureIcon
             isAttention:(BOOL *)isAttention;
- (NSMutableArray *)buildWithData:(NSArray *)data;

@end
