//
//  TeacherCatigoryModel.h
//  ERVICE
//
//  Created by apple on 3/30/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TeacherCatigoryModel : NSObject
@property (nonatomic,strong) NSString *image;
@property (nonatomic,strong) NSString *title;
@property (nonatomic,strong) NSString *categoryId;
- (id)initWithImage:(NSString *)imageurl title:(NSString *)title categoryId:(NSString *)categoryId;
- (NSMutableArray *)buildWithCategoryData:(NSArray *)data;
@end
