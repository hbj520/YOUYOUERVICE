//
//  AnnoucementModel.h
//  ERVICE
//
//  Created by apple on 3/31/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnnoucementModel : NSObject
@property (nonatomic,copy) NSString *articelId;
@property (nonatomic,copy) NSString *articleTitle;
- (id)initWithParameters:(NSString *)articelId arcticelTitle:(NSString *)articleTitle;
- (NSMutableArray *)buildWithData:(NSArray *)data;
@end
