//
//  FinanceItemModel.m
//  ERVICE
//
//  Created by apple on 3/31/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "FinanceItemModel.h"

@implementation FinanceItemModel
- (id)initWithParameters:(NSString *)exname exid:(NSString *)exid exInfo:(NSString *)exInfo image:(NSString *)imge authenArray:(NSArray *)authenArray num:(NSString *)num{
    FinanceItemModel *financeModel = [[FinanceItemModel alloc] init];
    financeModel.exid = exid;
    financeModel.exname = exname;
    financeModel.image = imge;
    financeModel.exInfo = exInfo;
    financeModel.authenArray = authenArray;
    financeModel.num = num;
    
    return financeModel;
}
- (NSMutableArray *)buildWithData:(NSArray *)data{
    NSMutableArray *financeArray = [NSMutableArray array];
    for (NSDictionary *dic in data) {
        NSString *exname = dic[@"ex_name"];
        NSString *exid = dic[@"id"];
        NSString *exInfo = dic[@"exc_information"];
        NSString *exImage = dic[@"excimg"];
        NSArray *authoArray = dic[@"rz"];
        NSNumber *num = dic[@"num"];
        NSString *number = [NSString stringWithFormat:@"%ld",num.integerValue];
 //       NSString *number = @"0";
        FinanceItemModel *model = [[FinanceItemModel alloc] initWithParameters:exname exid:exid exInfo:exInfo image:exImage authenArray:authoArray num:number];
        [financeArray addObject:model];
        
    }
    return financeArray;
}
@end
