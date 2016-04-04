//
//  TeacherAnnalyzeModel.h
//  ERVICE
//
//  Created by apple on 3/30/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TeacherCatigoryModel;
@class TeacherItemModel;
@interface TeacherAnnalyzeModel : NSObject
@property (nonatomic,strong) NSMutableArray *categoryArray;
@property (nonatomic,strong) NSMutableArray *articleArray;
@property (nonatomic,strong) NSString *thisCategory;

@end
