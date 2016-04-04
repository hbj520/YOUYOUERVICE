//
//  ActivityModel.h
//  ERVICE
//
//  Created by apple on 3/28/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityModel : NSObject
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *num;
@property (nonatomic,strong) NSString *starttime;
@property (nonatomic,strong) NSString *endtime;
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *activityId;
- (id)initWithParameters:(NSString *)title content:(NSString *)content num:(NSString *)num starttime:(NSString *)startime endtime:(NSString *)endtime image:(NSString *)imageurl activityId:(NSString *)activityId;
- (NSMutableArray *)buildWithData:(NSArray *)data;
@end
