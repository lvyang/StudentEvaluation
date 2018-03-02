//
//  AppDelegate.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/2/28.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "AppDelegate.h"
#import <AFNetworkReachabilityManager.h>
#import <YTKNetworkConfig.h>
#import <YTKNetworkAgent.h>
#import "BSUrlArgumentsFilter.h"
#import "BSSettings.h"
#import "BSNavigationViewController.h"
#import "BSLoginViewController.h"
#import "PersonCenterViewController.h"
#import "ReleaseRecordViewController.h"
#import "SelectMedalViewController.h"
#import "BSLoginManager.h"
#import "UIViewController+Addition.h"
#import "BSBaseRequest.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // Network configuration
    {
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
        
        YTKNetworkConfig *config = [YTKNetworkConfig sharedConfig];
        config.baseUrl = [BSSettings baseUrl];
        
        BSUrlArgumentsFilter *urlFilter = [BSUrlArgumentsFilter filterWithArguments:nil];
        [config addUrlFilter:urlFilter];
        
        NSSet *set = [NSSet setWithObjects:@"application/json", @"text/plain", @"text/javascript", @"text/json",@"text/html", nil];
        YTKNetworkAgent *agent = [YTKNetworkAgent sharedAgent];
        [agent setValue:set forKeyPath:@"jsonResponseSerializer.acceptableContentTypes"];
    }
    
    // 注册通知
    {
        [self registerNotification];
    }
    
    // ios11适配
    {
        [UITableView appearance].estimatedRowHeight = 0;
        [UITableView appearance].estimatedSectionHeaderHeight = 0;
        [UITableView appearance].estimatedSectionFooterHeight = 0;
        
        //iOS11 解决SafeArea的问题，同时能解决pop时上级页面scrollView抖动的问题
        if (@available(iOS 11, *)) {
            [UIScrollView appearance].contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    // Add root view controller
    {
        UIWindow *window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window = window;

        if ([[BSLoginManager shareManager] isLogin]) {
            [self loadContentViewcontroller];
        } else {
            [self loadLoginViewController];
        }
        
        [self.window makeKeyAndVisible];
    }
    
    return YES;
}

- (void)loadContentViewcontroller
{
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithHexString:@"54bfca"]} forState:UIControlStateSelected];
    
    SelectMedalViewController *releaseMedalVC = [[SelectMedalViewController alloc] initWithNibName:@"SelectMedalViewController" bundle:nil];
    BSNavigationViewController *releaseMedalNavi = [[BSNavigationViewController alloc] initWithRootViewController:releaseMedalVC];
    releaseMedalNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"颁发奖章" image:[[UIImage imageNamed:@"class_icon_reward_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"class_icon_reward_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    ReleaseRecordViewController *releaseRecordVC = [[ReleaseRecordViewController alloc] init];
    BSNavigationViewController *releaseRecordNavi = [[BSNavigationViewController alloc] initWithRootViewController:releaseRecordVC];
    releaseRecordNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"颁发记录" image:[[UIImage imageNamed:@"class_icon_comment_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"class_icon_comment_sel.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    PersonCenterViewController *personalCenterVC = [[PersonCenterViewController alloc] initWithNibName:@"PersonCenterViewController" bundle:nil];
    BSNavigationViewController *personalCenterNavi = [[BSNavigationViewController alloc] initWithRootViewController:personalCenterVC];
    personalCenterNavi.tabBarItem = [[UITabBarItem alloc] initWithTitle:@"个人中心" image:[[UIImage imageNamed:@"class_icon_personal_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:@"class_icon_personal_sal.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];

    UITabBarController *tab = [[UITabBarController alloc] init];
    [tab setViewControllers:@[releaseMedalNavi, releaseRecordNavi, personalCenterNavi]];
    
    self.window.rootViewController = tab;
}

- (void)loadLoginViewController
{
    BSLoginViewController *vc = [[BSLoginViewController alloc] initWithNibName:@"BSLoginViewController" bundle:nil];
    BSNavigationViewController *navi = [[BSNavigationViewController alloc] initWithRootViewController:vc];
    self.window.rootViewController = navi;
}

- (void)registerNotification
{
    // 登录成功通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogin:)
                                             name    :BS_LOGIN_SUCCESS
                                             object  :nil];
    
    // 退出登录通知
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogout:)
                                             name    :BS_LOGOUT_SUCCESS
                                             object  :nil];
    
    // 账号在其他设备上登录
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessTokenInvalidate:)
                                             name    :DODOEDU_ACCESS_TOKEN_ERROR_NOTIFICATION
                                             object  :nil];
}

#pragma mark - NSNotification Method
- (void)didLogin:(NSNotification *)notification
{
    [self loadContentViewcontroller];
}

- (void)didLogout:(NSNotification *)notification
{
    [self loadLoginViewController];
}

- (void)accessTokenInvalidate:(NSNotification *)notification
{
    UIViewController *topVC = [self.window.rootViewController topMostViewController];
    
    [MBProgressHUD hideHUDForView:topVC.view animated:YES];
    MBProgressHUD *hub = [MBProgressHUD showHUDAddedTo:topVC.view animated:YES];
    hub.mode = MBProgressHUDModeText;
    hub.detailsLabelText = @"token失效，请重新登录";
    hub.detailsLabelFont = [UIFont systemFontOfSize:16];
    hub.completionBlock = ^{
        UIViewController    *topMostViewController = [self.window.rootViewController topMostViewController];
        BSLoginViewController *loginVC = [[BSLoginViewController alloc] initWithNibName:@"BSLoginViewController" bundle:nil];

        if (![NSStringFromClass([loginVC class]) isEqualToString:NSStringFromClass([topMostViewController class])]) {
            [topMostViewController presentViewController:loginVC animated:YES completion:nil];
        }
    };
    [hub hide:YES afterDelay:2];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
