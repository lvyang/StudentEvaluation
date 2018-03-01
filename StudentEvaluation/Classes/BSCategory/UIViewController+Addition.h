//
//  UIViewController+Addition.h
//  Pods
//
//  Created by Yang.Lv on 2017/3/31.
//
//

#import <UIKit/UIKit.h>

@interface UIViewController (Addition)

/**
 *  @description: 获取某个根视图控制器上的最上面的一个controller
 */
- (UIViewController *)topMostViewController;

/**
 *  @description: 获取指定控制器上最上面的一个controller
 */
- (UIViewController *)topViewControllerOnRootViewController:(UIViewController *)rootViewController;

@end
