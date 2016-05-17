//
//  HomeTabbarViewController.m
//  ERVICE
//
//  Created by apple on 16/3/14.
//  Copyright © 2016年 hbjApple. All rights reserved.
//

#import "HomeTabbarViewController.h"
#import "HexColor.h"
//#import "NSObject+EaseMob.h"
@interface HomeTabbarViewController ()<EMChatManagerDelegate>
{
    NSArray *titleArrays;
    NSMutableArray *menusVCs;//tabbars的控制器们
}
@property (nonatomic,strong) UIStoryboard *homePageSB;
@property (nonatomic,strong) UIStoryboard *annalyzeSB;
@property (nonatomic,strong) UIStoryboard *activitySB;
@property (nonatomic,strong) UIStoryboard *announcementSB;
@property (nonatomic,strong) UIStoryboard *personalSB;
@end


@implementation HomeTabbarViewController
- (UIStoryboard *)homePageSB{
    if (!_homePageSB) {
        _homePageSB = [UIStoryboard storyboardWithName:@"Homepage" bundle:[NSBundle mainBundle]];
    }
    return _homePageSB;
}

- (UIStoryboard *)annalyzeSB{
    if (!_annalyzeSB) {
        _annalyzeSB = [UIStoryboard storyboardWithName:@"Annalyze" bundle:[NSBundle mainBundle]];
    }
    return _annalyzeSB;
}

- (UIStoryboard *)activitySB{
    if (!_activitySB) {
        _activitySB = [UIStoryboard storyboardWithName:@"Activity" bundle:[NSBundle mainBundle]]
        ;
    }
    return _activitySB;
}

- (UIStoryboard *)announcementSB{
    if (!_announcementSB) {
        _announcementSB = [UIStoryboard storyboardWithName:@"Announcement" bundle:[NSBundle mainBundle]];
    }
    return _announcementSB;
}
- (UIStoryboard *)personalSB{
    if (!_personalSB) {
        _personalSB = [UIStoryboard storyboardWithName:@"Personal" bundle:[NSBundle mainBundle]];
    }
    return _personalSB;
}
- (void)viewDidLoad {
    [super viewDidLoad];
   
    // Do any additional setup after loading the view.
    self.tabBar.tintColor = [UIColor colorWithHexString:@"ff5000"];
    menusVCs = [NSMutableArray array];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"HomeTabbars" ofType:@"json"];
    NSData *data = [[NSData alloc] initWithContentsOfFile:path];
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *array = dict[@"tabBarMenus"];
    for (NSDictionary *dic in array) {
        UITabBarItem *tabbarItem = [[UITabBarItem alloc] init];
        [tabbarItem setImage:[UIImage imageNamed:dic[@"image"]]];
        [tabbarItem setSelectedImage:[UIImage imageNamed:dic[@"select_image"]]];
        [tabbarItem setTitle:dic[@"title"]];
        SEL selector = NSSelectorFromString(dic[@"storybordId"]);
        IMP imp = [self methodForSelector:selector];
        UIStoryboard * (*func)(id,SEL) = (void *)imp;
        UIStoryboard *sb = func(self,selector);
        UIViewController *vc = [sb instantiateInitialViewController];
        vc.tabBarItem = tabbarItem;
        [menusVCs addObject:vc];
        
    }
     [self registerNotifications];
    self.viewControllers = menusVCs;
}
-(void)registerNotifications{
    [self unregisterNotifications];
    [[EMClient sharedClient].chatManager addDelegate:self delegateQueue:nil];
    //[[ sharedInstance].chatManager addDelegate:self delegateQueue:nil];
}
-(void)unregisterNotifications{
   // [[EaseMob sharedInstance].chatManager removeDelegate:self];
    [[EMClient sharedClient].chatManager removeDelegate:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - private
- (void)setUpUnreadMessageCount{
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
//    if (_chatListVC) {
//        if (unreadCount) {
//            _chatListVC.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",(long)unreadCount];
//        }else{
//            _chatListVC.tabBarItem.badgeValue = nil;
//        }
//    }
    
    UIApplication *application = [UIApplication sharedApplication];
    [application setApplicationIconBadgeNumber:unreadCount];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
