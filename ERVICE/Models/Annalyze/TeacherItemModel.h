//
//  TeacherItemModel.h
//  ERVICE
//
//  Created by apple on 3/21/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherItemModel : NSObject
@property (nonatomic,copy) NSString *image;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *itemId;
@property (nonatomic,assign) BOOL isNew;
- (id)initWithImge:(NSString *)image title:(NSString *)title content:(NSString *)content itemId:(NSString *)itemId;
- (NSMutableArray *)builderWithMenus:(NSArray *)menus;
@end
