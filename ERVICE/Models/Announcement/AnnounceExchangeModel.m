//
//  AnnounceExchangeModel.m
//  ERVICE
//
//  Created by apple on 3/31/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "AnnounceExchangeModel.h"

@implementation AnnounceExchangeModel
- (id)initWithParameter:(NSString *)exchangeId exchangeName:(NSString *)exchangeName exchangeImageurl:(NSString *)exchangeImageurl{
    AnnounceExchangeModel *model = [[AnnounceExchangeModel alloc] init];
    model.exchangeId = exchangeId;
    model.exchangeImageurl = exchangeImageurl;
    model.exchangName = exchangeName;
    return model;
}
- (NSMutableArray *)buildWithData:(NSArray *)data{
    NSMutableArray *exchangeArray = [NSMutableArray array];
    for (NSDictionary *exchangeDic in data) {
        NSString *exchangeId = exchangeDic[@"ex_id"];
        NSString *exName = exchangeDic[@"ex_name"];
        NSString *exImageurl = exchangeDic[@"excimg"];
        AnnounceExchangeModel *model = [[AnnounceExchangeModel alloc] initWithParameter:exchangeId exchangeName:exName exchangeImageurl:exImageurl];
        [exchangeArray addObject:model];
    }
    return exchangeArray;
}
@end
