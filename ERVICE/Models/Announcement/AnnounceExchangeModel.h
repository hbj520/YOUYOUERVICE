//
//  AnnounceExchangeModel.h
//  ERVICE
//
//  Created by apple on 3/31/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnounceExchangeModel : NSObject
@property (nonatomic,strong) NSString *exchangeId;
@property (nonatomic,strong) NSString *exchangName;
@property (nonatomic,strong) NSString *exchangeImageurl;
- (id)initWithParameter:(NSString *)exchangeId exchangeName:(NSString *)exchangeName exchangeImageurl:(NSString *)exchangeImageurl;
- (NSMutableArray *)buildWithData:(NSArray *)data;
@end
