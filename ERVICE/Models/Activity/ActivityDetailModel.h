//
//  ActivityDetailModel.h
//  ERVICE
//
//  Created by apple on 3/29/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActivityDetailModel : NSObject
@property (nonatomic,strong) NSString *starttime;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *imageUrl;
@property (nonatomic,strong) NSString *innum;//活动限制人数
@property (nonatomic,strong) NSString *num;//活动参与人数
@property (nonatomic,strong) NSString *endtime;
@property (nonatomic,strong) NSString *mystatus;//参与状态

- (id)initWithTitle:(NSString *)title
              image:(NSString *)imageurl
                num:(NSString *)num
              innum:(NSString *)innum
          starttime:(NSString *)starttime
            endtime:(NSString *)endtime
            content:(NSString *)content
           mystatus:(NSString *)mystatus;
- (ActivityDetailModel *)buildWithData:(NSDictionary *)data;
@end
