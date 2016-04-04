//
//  Tools.m
//  CRM
//
//  Created by ebadu on 14-9-2.
//  Copyright (c) 2014年 Razi. All rights reserved.
//

#import "Tools.h"
#import "SecurityUtil.h"
@implementation Tools



+ (void)hideKeyBoard{
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    if (!keyWindow) {
        NSArray *array=[UIApplication sharedApplication].windows;
        keyWindow=[array objectAtIndex:0];
    }
    [keyWindow endEditing:YES];
}

+ (NSString *)documentPath:(NSString *)file{
    
    NSArray*paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    NSString *documentsDirectory= [paths objectAtIndex:0];
    NSString *savedImagePath=[documentsDirectory stringByAppendingPathComponent:file];
    return savedImagePath;
}



+ (NSString *)getZoneDataURL
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    NSString *Json_path = [path stringByAppendingPathComponent:@"province.json"];

    return Json_path;
}

//是否3.5存小屏幕
+(BOOL) isSmallScreen
{
    BOOL isSmall=NO;
    CGRect rx = [ UIScreen mainScreen ].bounds;
    if(rx.size.height<=480)
        isSmall=YES;
    
    return isSmall;
}

+ (CGSize)stringToSize:(NSString *)str{
    
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{
                                  NSFontAttributeName :font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [str boundingRectWithSize:CGSizeMake(230, 999)
                                                    options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                                 attributes:attributes
                                                    context:nil].size;
    return contentSize;
}

+(CGSize)stringToAttributeSize:(NSMutableAttributedString *)str
{
    UIFont *font = [UIFont fontWithName:@"Arial" size:14];
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{
                                  NSFontAttributeName :font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [str.string boundingRectWithSize:CGSizeMake(230, 999)
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes:attributes
                                           context:nil].size;
    return contentSize;
}

+ (CGSize)stringToSizeProduct:(NSString *)str
                         font:(UIFont *)font
                       cgsize:(CGSize)cgsize{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary * attributes = @{
                                  NSFontAttributeName :font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize contentSize = [str boundingRectWithSize:cgsize
                                           options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                        attributes:attributes
                                           context:nil].size;
    return contentSize;
}

+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Beijing"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}

+ (void)showStatusBarQueryStr:(NSString *)tipStr{

    [JDStatusBarNotification showWithStatus:tipStr styleName:JDStatusBarStyleSuccess];
    [JDStatusBarNotification showActivityIndicator:YES indicatorStyle:UIActivityIndicatorViewStyleWhite];
    
}
+ (void)showStatusBarSuccessStr:(NSString *)tipStr{
    if ([JDStatusBarNotification isVisible]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
            [JDStatusBarNotification showWithStatus:tipStr dismissAfter:1.5 styleName:JDStatusBarStyleSuccess];
        });
    }else{
        [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
        [JDStatusBarNotification showWithStatus:tipStr dismissAfter:1.0 styleName:JDStatusBarStyleSuccess];
    }
}
+ (void)showStatusBarErrorStr:(NSString *)errorStr{
    if ([JDStatusBarNotification isVisible]) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
            [JDStatusBarNotification showWithStatus:errorStr dismissAfter:1.5 styleName:JDStatusBarStyleError];
        });
    }else{
        [JDStatusBarNotification showActivityIndicator:NO indicatorStyle:UIActivityIndicatorViewStyleWhite];
        [JDStatusBarNotification showWithStatus:errorStr dismissAfter:1.5 styleName:JDStatusBarStyleError];
    }
}
//计算几行
//计算几行
+ (NSInteger)simulateLinesWithArray:(NSInteger)arrayCout withList:(NSInteger)List{
    NSInteger lines = 0;
    if (arrayCout%List == 0) {
        lines = arrayCout/List;
    }else{
        lines = arrayCout/List + 1;
    }
    return lines;
}
//对登录密码加密
+ (NSString *)loginPasswordSecurityLock:(NSString *)password{
    ;

    
    return     [SecurityUtil encryptMD5String:[SecurityUtil encodeBase64String:[NSString stringWithFormat:@"%@yykjAwdx",[SecurityUtil encryptMD5String:password]]]];
}
@end
