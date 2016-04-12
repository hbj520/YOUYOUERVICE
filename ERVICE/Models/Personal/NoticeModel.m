//
//  NoticeModel.m
//  ERVICE
//
//  Created by youyou on 16/4/12.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel
- (id)initWithNoticeId:(NSString *)noticeId
                   title:(NSString *)title
              createTime:(NSString *)createTime
                 fixTime:(NSString *)fixTime
                 image:(NSString *)image{
    NoticeModel *model = [[NoticeModel alloc] init];
    model.noticeId = noticeId;
    model.title = title;
    model.createTime = createTime;
    model.fixTime = fixTime;
    model.image = image;
    return model;
}
- (NSMutableArray *)buidWithData:(NSArray *)data{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *createTime = dic[@"ctime"];
        NSString *noticeId = dic[@"id"];
        NSString *image = dic[@"imgthumb"];
        NSString *fixTime = dic[@"mtime"];
        NSString *title = dic[@"title"];
        NoticeModel *model = [[NoticeModel alloc] initWithNoticeId:noticeId
                                                             title:title
                                                        createTime:createTime
                                                           fixTime:fixTime
                                                             image:image];
        
        [modelArray addObject:model];
    }
    return modelArray;
}
@end
