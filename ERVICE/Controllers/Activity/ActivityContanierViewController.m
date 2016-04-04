//
//  ActivityContanierViewController.m
//  ERVICE
//
//  Created by apple on 3/22/16.
//  Copyright © 2016 hbjApple. All rights reserved.
//

#import "ActivityContanierViewController.h"
#import "AllActivityViewController.h"
#import "MyActivityViewController.h"
@interface ActivityContanierViewController ()
{
    AllActivityViewController *allActivityVC;
    MyActivityViewController *myActivityVC;
}
@property (weak, nonatomic) IBOutlet UISegmentedControl *mSegmentControl;
@end

@implementation ActivityContanierViewController
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.skipIntermediateViewControllers = YES;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.containerView setScrollEnabled:YES];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationController.navigationBar.translucent = NO;
    self.tabBarController.tabBar.translucent = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
#pragma mark - xlswipe
- (NSArray *)swipeContainerControllerViewControllers:(XLSwipeContainerController *)swipeContainerController{
    if (!allActivityVC) {
        UINavigationController *allNav = [self.storyboard instantiateViewControllerWithIdentifier:@"allActivityNav"];
        allActivityVC = (AllActivityViewController *)allNav.childViewControllers[0];    }
    if (!myActivityVC) {
        UINavigationController *navMy = [self.storyboard instantiateViewControllerWithIdentifier:@"myActivityNav"];
        myActivityVC = (MyActivityViewController *)navMy.childViewControllers[0];
    }
    return @[allActivityVC,myActivityVC];
}
@end
