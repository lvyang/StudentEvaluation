//
//  UIViewController+Addition.m
//  Pods
//
//  Created by Yang.Lv on 2017/3/31.
//
//

#import "UIViewController+Addition.h"

@implementation UIViewController (Addition)

- (UIViewController *)topMostViewController
{
    return [self topViewControllerOnRootViewController:[UIApplication sharedApplication].keyWindow.rootViewController];
}

- (UIViewController *)topViewControllerOnRootViewController:(UIViewController *)rootViewController
{
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerOnRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        return [self topViewControllerOnRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerOnRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

@end
