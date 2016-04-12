 //
//  MyAPI.m
//  ERVICE
//
//  Created by apple on 3/25/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//
#import <AFNetworking/AFNetworking.h>
#import <AFNetworking/AFURLResponseSerialization.h>
#import "MyAPI.h"
#define BaseUrl @"http://60.173.235.34:9999/svnupdate/app/"
//tools
#import "Config.h"

//models
#import "UserInfoModel.h"
#import "HomepageBannerModel.h"
#import "HomepageExchangeModel.h"
#import "LecturerModel.h"
#import "ActivityModel.h"
#import "ActivityDetailModel.h"
#import "FinanceItemModel.h"
#import "FinanceModel.h"
#import "AnnounceExchangeModel.h"
#import "AnnoucementModel.h"
#import "FamousTechListModel.h"
#import "CustomerServiceModel.h"

#import "TeacherCatigoryModel.h"
#import "TeacherAnnalyzeModel.h"
#import "TeacherItemModel.h"
#import "MyTeacherModel.h"
#import "NoticeModel.h"

@interface MyAPI()
@property NSString *mBaseUrl;
@property (nonatomic, strong) AFHTTPRequestOperationManager *manager;
@end
@implementation MyAPI
- (id)init{
    self = [super init];
    if (self) {

        self.manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:BaseUrl]] ;
        self.manager.responseSerializer.acceptableContentTypes =  [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
        self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    return self;
}
+ (MyAPI *)sharedAPI{
    static MyAPI *sharedAPIInstance = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedAPIInstance = [[self alloc] init];
    });
    return sharedAPIInstance;
}
- (void)cancelAllOperation{
    [self.manager.operationQueue cancelAllOperations];
}

#pragma mark - 登录借口
//************登录
- (void)LoginWithNumber:(NSString *)phoneNumber
               password:(NSString *)password
                 result:(StateBlock)result
            errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                @"phone":phoneNumber,
                                @"userpwd":password
                                 };
    [self.manager POST:@"nos_login" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *state = responseObject[@"status"];
        NSString *information = responseObject[@"info"];
        if ([state isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            UserInfoModel *userinfo = [[UserInfoModel alloc] buildWithDatas:data];
            //保存个人信息至本地
            [[Config Instance] saveUserid:userinfo.uid userName:userinfo.username userPhoneNum:userinfo.phone token:userinfo.token icon:userinfo.iconUrl
             ];
            result(YES,information);
            
        }else{
            result(NO,information);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
//上传头像
- (void)uploadImage:(NSData *)imageData
             result:(StateBlock)result
        errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameter = @{
                                @"token":KToken,
                                @"image":imageData
                                };
    [self.manager POST:@"nos_userimage" parameters:parameter success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        if ([status isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            NSString *imageUrl = data[@"imgthumb"];
            result(YES,imageUrl);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
    
}
//上传图片
- (void)postFileAndImage:(NSString *)filePathStr
                    type:(NSString *)type
                    name:(NSString *)name
                  result:(void (^)(BOOL success, NSString * msg,id object))result{
    NSDictionary *parameter = @{
                                @"token":KToken,
                                    };
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"nos_userimage" parameters:parameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePathStr] name:@"fname" fileName:name mimeType:@"image/jpeg" error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSProgress *progress = nil;
    
    AFJSONResponseSerializer * s= [AFJSONResponseSerializer serializer];
    s.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json", @"text/plain",@"application/x-www-form-urlencoded",nil];
    manager.responseSerializer = s;
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:&progress completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        
        
        if (error) {
            result(NO,@"fail",responseObject);
        } else {
            result(YES,@"sucess",responseObject);
        }
    }];
    
    [uploadTask resume];
}
#pragma mark - 退出登录
- (void)LoginOutWithResult:(StateBlock)result
               errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"userexit" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *info = responseObject[@"info"];
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            result(YES,info);
        }else{
            result(NO,info);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 获取首页信息
- (void)getHomepageDataWithResult:(ArrayBlock)result
                      errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_shouye" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
         NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
          result(NO,@"登录超时",nil);
        }
            if ([status isEqualToString:@"1"]) {
                NSDictionary *data = responseObject[@"data"];
                NSArray *bannerArray = data[@"banner"];
                NSArray *exchangeArray = data[@"exchange"];
                //首页滚动视图数据赋值
                NSMutableArray *bannerData = [[HomepageBannerModel alloc] buildData:bannerArray];
                //首页交易所数据赋值
                NSMutableArray *exchangeData = [[HomepageExchangeModel alloc] buildWithData:exchangeArray];
                result(YES,@"获取成功",@[bannerData,exchangeData]);
            }else{
                result(NO,@"获取失败",nil);
            }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];

}
#pragma mark - 获取名人榜单前几名
- (void)famousTopThreeWithResult:(ArrayBlock)result
                     errorResult:(ErrorBlock)errorResult{
    NSDictionary *paramters = @{
                                @"token":KToken
                                };
    [self.manager POST:@"nos_topteacher" parameters:paramters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *modelArray = [[FamousTechListModel alloc] buildData:data];
            result(YES,@"下载完成",modelArray);
        }else{
            result(NO,@"下载失败",nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 获取名人榜列表
- (void)famousListWithPage:(NSString *)page result:(ArrayBlock)result errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"page":page
                                 ,@"token":KToken
                                 };
    [self.manager POST:@"nos_starteacher" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }

        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *modelArray = [[FamousTechListModel alloc] buildData:data];
            result(YES,@"下载完成",modelArray);
        }else{
            result(NO,@"下载失败",nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}

#pragma mark - 获取客服列表
- (void)customerServiceListWithPage:(NSString *)page
                             result:(ArrayBlock)result
                        errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"page":page,
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_getserver" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"1"]) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *modelArray =  [[CustomerServiceModel alloc] buildWithData:data];
            result(YES,@"下载完成",modelArray);
        }else{
            result(NO,info,nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}

#pragma mark - 交易所下讲师列表
//exid --交易所id
- (void)getLecturerListWithExId:(NSString *)exid
                         result:(ArrayBlock )result
                    errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                @"exid":exid,
                                @"token":KToken
                                };
    [self.manager POST:@"nos_teachers" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]) {
            NSArray *data = responseObject[@"data"];
           NSMutableArray *lecArray = [[LecturerModel alloc] buildWithData:data];
            result(YES,@"下载成功",lecArray);
        }else{
            result(NO,@"暂无数据",nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}

#pragma mark - 点击关注
- (void)attentionTapWithLecturerId:(NSString *)lecturerId
                            result:(StateBlock)result
                       errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"tid":lecturerId,
                                 @"token":KToken
                                 };
    [self.manager POST:@"addAttention" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"1"]) {
            result(YES,info);
        }else{
            result(NO,info);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        
        errorResult(error);
    }];
}

#pragma mark - 点击取消关注
- (void)noAttentionWithLecturerId:(NSString *)lecturerId
                           result:(StateBlock)result
                      errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"tid":lecturerId,
                                 @"token":KToken
                                 };
    [self.manager POST:@"delAttention" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"1"]) {
            result(YES,info);
        }else{
            result(NO,info);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}

#pragma mark - 老师详情页
- (void)LecturerDetailWithTeacherId:(NSString *)teacherId
                          articleId:(NSString *)articleId
                               page:(NSString *)page
                             result:(ModelBlock)result
                        errorResult:(ErrorBlock)errorResult{
    
    NSDictionary *parameters = @{
                                 @"teacher_id":teacherId,
                                 @"ctgy":articleId,
                                 @"page":page,
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_teachers_info" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSDictionary *dic = responseObject[@"data"];
            NSArray *category = dic[@"cat"];
            NSString *thiscat = dic[@"thiscat"];
           NSMutableArray *categoryArray = [[TeacherCatigoryModel alloc] buildWithCategoryData:category];
            NSArray *list = dic[@"list"];
            NSMutableArray *listArray = [[TeacherItemModel alloc] builderWithMenus:list];
            TeacherAnnalyzeModel *model = [[TeacherAnnalyzeModel alloc] init];
            model.categoryArray = categoryArray;
            model.articleArray = listArray;
            model.thisCategory = thiscat;
            result(YES,@"下载成功",model);
        }else{
            result(NO,@"下载失败",nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
        
    }];
    
    
}

#pragma mark - 财经分析
- (void)FinanceAnnalyzeListResult:(ModelBlock)result errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_fenxi" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *banner = data[@"banner"];
            NSMutableArray *bannerArray = [[HomepageBannerModel alloc] buildData:banner];
            
            NSArray *exchanges = data[@"exchange"];
            NSMutableArray *exchangeArray = [[FinanceItemModel alloc] buildWithData:exchanges];
            
            FinanceModel *financeModel = [[FinanceModel alloc] init];
            financeModel.banners = bannerArray;
            financeModel.exchanges = exchangeArray;
            result(YES,@"下载完成",financeModel);
            
        }else {
            result(NO,@"下载失败!!",nil);
        }
        
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
    
    
}
#pragma mark - 公告banner
- (void)AnnouncementBannerWithResult:(ArrayBlock)result
                         errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };

    [self.manager POST:@"notice_banner" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
                    NSArray *data = responseObject[@"data"];
                    NSMutableArray *dataBanner = [[HomepageBannerModel alloc] buildData:data];
                    result(YES,@"下载完成",dataBanner);
        }else{
                    result(NO,@"下载失败",nil);
              }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 公告交易所
- (void)AnnouncementExchangeWithResult:(ArrayBlock)result
                           errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"exchange" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *cat = data[@"cat"];
            NSMutableArray *catArray = [[AnnounceExchangeModel alloc] buildWithData:cat];
            result(YES,@"下载完成",catArray);
        }else{
            result(NO,@"下载失败",nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 通告列表
- (void)AnnounceListWithParamters:(NSString *)exid
                             page:(NSString *)page
                           result:(ArrayBlock)result
                      errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"exc_id":exid,
                                 @"page":page,
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_notice" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *list = data[@"list"];
            NSMutableArray *listArray = [[AnnoucementModel alloc] buildWithData:list];
            result(YES,@"下载完成",listArray);
        }else{
            result(NO,@"下载失败",nil);
        }
      
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark -全部活动banner广告
- (void)loadAllActivityBannerWithResult:(ArrayBlock)result
                            errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"activity_banner" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *dataBanner = [[HomepageBannerModel alloc] buildData:data];
            result(YES,@"下载完成",dataBanner);
        }else{
            result(NO,@"下载失败",nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark -全部活动
- (void)loadAllActivityWithPage:(NSString *)page
                         result:(ArrayBlock)result
                     errorBlock:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"page":page,
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_activity" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *activityData;
            if (data.count > 0) {
                activityData  = [[ActivityModel alloc] buildWithData:data];
            }
            result(YES,@"下载完成",activityData);
        }else{
            result(NO,@"下载失败",nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}

#pragma mark -我的活动
- (void)loadMyActivityWithPage:(NSString *)page
                        result:(ArrayBlock)result
                    errorBlock:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"page":page,
                                 @"token":KToken
                                 };
    [self.manager GET:@"my_activity" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]) {
            NSArray *data = responseObject[@"data"];
            NSMutableArray *activityData = [[ActivityModel alloc] buildWithData:data];
            result(YES,@"下载完成",activityData);
        }else{
            result(NO,@"下载失败",nil);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark -活动详情
- (void)loadActivityDetailWithActivityId:(NSString *)activityId
                                  result:(ModelBlock)result
                             errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"aid":activityId,
                                 @"token":KToken
                                 };
    [self.manager POST:@"nos_activity_info" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([responseObject[@"status"] isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            ActivityDetailModel *actModel = [[ActivityDetailModel alloc] buildWithData:data];
            result(YES,@"加载成功",actModel);
        }else{
            result(NO,@"加载失败",nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}

#pragma mark - 参加活动
- (void)apartActivityWithActivityId:(NSString *)activityId
                             result:(StateBlock)result
                        errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"activityid":activityId,
                                 @"token":KToken
                                 };
    [self.manager POST:@"enroll_activity" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时");
        }
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"1"]) {
            result(YES,info);
        }else {
            result(NO,info);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 我的老师
- (void)myTeacherWithResult:(ArrayBlock)result errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken
                                 };
    [self.manager POST:@"user_teacher_info" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        
        NSString *status = responseObject[@"status"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *list = data[@"list"];
          NSMutableArray *techArray = [[MyTeacherModel alloc] buildWithData:list];
            result(YES,@"下载成功",techArray);
        }else{
            result(NO,@"下载失败",nil);
        }
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
    }];
}
#pragma mark - 消息列表
- (void)noticeListWithPage:(NSString *)page
                    result:(ArrayBlock)result
               errorResult:(ErrorBlock)errorResult{
    NSDictionary *parameters = @{
                                 @"token":KToken,
                                 @"page":page
                                 };
    [self.manager POST:@"nos_sysnotice" parameters:parameters success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
        NSString *status = responseObject[@"status"];
        NSString *info = responseObject[@"info"];
        if ([status isEqualToString:@"-1"]) {//超时处理
            result(NO,@"登录超时",nil);
        }
        if ([status isEqualToString:@"1"]) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *list = data[@"list"];
            NSMutableArray *modelsArray = [[NoticeModel alloc] buidWithData:list];
            result(YES,info,modelsArray);
        }
        
    } failure:^(AFHTTPRequestOperation * _Nullable operation, NSError * _Nonnull error) {
        errorResult(error);
        
    }];
    
}
@end
