//
//  AppDelegate.h
//  ERVICE
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSString *appKey = @"fe43cc6c3475826bf5de320e";
static NSString *channel = @"Publish channel";
static BOOL isProduction = NO;
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) UIStoryboard *mStorybord;
@property (strong,nonatomic) UIStoryboard *annalyzeStorybord;

@end

