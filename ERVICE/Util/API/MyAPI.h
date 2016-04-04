//
//  MyAPI.h
//  ERVICE
//
//  Created by apple on 3/25/16.
//  Copyright © 2016 hbjApple. All rights reserved.
// 下载类

#import <Foundation/Foundation.h>
typedef void (^VoidBlock) (void);
typedef void (^StateBlock) (BOOL sucess, NSString *msg);
typedef void (^ModelBlock) (BOOL success, NSString *msg, id object);
typedef void (^ArrayBlock) (BOOL success, NSString *msg, NSMutableArray *arrays);
typedef void (^ErrorBlock) (NSError *enginerError);

@interface MyAPI : NSObject
+ (MyAPI *)sharedAPI;

//取消所有网路全部请求
- (void)cancelAllOperation;

#pragma mark - 登录借口
//************登录
//
- (void)LoginWithNumber:(NSString *)phoneNumber
               password:(NSString *)password
                 result:(StateBlock)result
            errorResult:(ErrorBlock)errorResult;
#pragma mark - 获取首页信息
- (void)getHomepageDataWithResult:(ArrayBlock)result
                      errorResult:(ErrorBlock)errorResult;
#pragma mark - 交易所下讲师列表
//exid --交易所id
- (void)getLecturerListWithExId:(NSString *)exid
                         result:(ArrayBlock )result
                    errorResult:(ErrorBlock)errorResult;
#pragma mark - 点击关注
- (void)attentionTapWithLecturerId:(NSString *)lecturerId
                            result:(StateBlock)result
                       errorResult:(ErrorBlock)errorResult;
#pragma mark - 点击取消关注
- (void)noAttentionWithLecturerId:(NSString *)lecturerId
                           result:(StateBlock)result
                      errorResult:(ErrorBlock)errorResult;

#pragma mark - 老师详情页
- (void)LecturerDetailWithTeacherId:(NSString *)teacherId
                          articleId:(NSString *)articleId
                               page:(NSString *)page
                             result:(ModelBlock)result
                        errorResult:(ErrorBlock)errorResult;


#pragma mark - 财经分析
- (void)FinanceAnnalyzeListResult:(ModelBlock)result errorResult:(ErrorBlock)errorResult;
#pragma mark - 公告banner
- (void)AnnouncementBannerWithResult:(ArrayBlock)result
                         errorResult:(ErrorBlock)errorResult;
#pragma mark - 公告交易所
- (void)AnnouncementExchangeWithResult:(ArrayBlock)result
                           errorResult:(ErrorBlock)errorResult;
#pragma mark - 通告列表
- (void)AnnounceListWithParamters:(NSString *)exid
                             page:(NSString *)page
                           result:(ArrayBlock)result
                      errorResult:(ErrorBlock)errorResult;
#pragma mark -全部活动banner广告
- (void)loadAllActivityBannerWithResult:(ArrayBlock)result
                            errorResult:(ErrorBlock)errorResult;
#pragma mark -全部活动
- (void)loadAllActivityWithPage:(NSString *)page
                         result:(ArrayBlock)result
                     errorBlock:(ErrorBlock)errorResult;

#pragma mark -我的活动
- (void)loadMyActivityWithPage:(NSString *)page
                        result:(ArrayBlock)result
                    errorBlock:(ErrorBlock)errorResult;
#pragma mark -活动详情
- (void)loadActivityDetailWithActivityId:(NSString *)activityId
                                  result:(ModelBlock)result
                             errorResult:(ErrorBlock)errorResult;
#pragma mark - 参加活动
- (void)apartActivityWithActivityId:(NSString *)activityId
                             result:(StateBlock)result
                        errorResult:(ErrorBlock)errorResult;
@end
