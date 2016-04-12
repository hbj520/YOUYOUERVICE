//
//  NoticeModel.h
//  ERVICE
//
//  Created by youyou on 16/4/12.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoticeModel : NSObject
@property (nonatomic,strong) NSString *noticeId;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *createTime;
@property (nonatomic,strong) NSString *fixTime;
@property (nonatomic,strong) NSString *image;
- (id)initWithNoticeId:(NSString *)noticeId
                   title:(NSString *)title
              createTime:(NSString *)createTime
               fixTime:(NSString *)fixTime
                 image:(NSString *)image;
- (NSMutableArray *)buidWithData:(NSArray *)data;
@end
