//
//  AnnoucementModel.m
//  ERVICE
//
//  Created by apple on 3/31/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "AnnoucementModel.h"

@implementation AnnoucementModel
- (id)initWithParameters:(NSString *)articelId arcticelTitle:(NSString *)articleTitle{
    AnnoucementModel *model  = [[AnnoucementModel alloc] init];
    model.articelId = articelId;
    model.articleTitle = articleTitle;
    return model;
}
- (NSMutableArray *)buildWithData:(NSArray *)data{
    NSMutableArray *modelArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *articleId = dic[@"id"];
        NSString *articelTitle  = dic[@"title"];
        AnnoucementModel *model = [[AnnoucementModel alloc] initWithParameters:articleId arcticelTitle:articelTitle];
        [modelArray addObject:model];
    }
    return modelArray;
}
@end
