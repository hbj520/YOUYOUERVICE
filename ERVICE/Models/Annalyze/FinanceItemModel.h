//
//  FinanceItemModel.h
//  ERVICE
//
//  Created by apple on 3/31/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FinanceItemModel : NSObject
@property (nonatomic,copy) NSString *exname;
@property (nonatomic,copy) NSString *exid;
@property (nonatomic,copy) NSString *exInfo;
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSArray *authenArray;//认证
@property (nonatomic,copy) NSString *num;

- (id)initWithParameters:(NSString *)exname exid:(NSString *)exid exInfo:(NSString *)exInfo image:(NSString *)imge authenArray:(NSArray *)authenArray num:(NSString *)num;
- (NSMutableArray *)buildWithData:(NSArray *)data;
@end
