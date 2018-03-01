//
//  BSViewController.h
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/9/23.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "LYBaseViewController.h"
#import "UIColor+Hex.h"
#import "BSErrorPage.h"
#import <Masonry.h>

/**
 * 针对本App进行个性化定制的基础 controller
 */
@interface BSViewController : LYBaseViewController

@property (nonatomic, strong, readonly) BSErrorPage *errorPage;

// custom navigation back item
- (void)addBackButtonItem;
- (void)removeBackButtonItem;

// Error page
- (BSErrorPage *)showErrorPageOnView:(UIView *)superView target:(id)target selector:(SEL)selector object:(id)object;
- (BSErrorPage *)showErrorPageOnView:(UIView *)superView belowView:(UIView *)bellowView target:(id)target selector:(SEL)selector object:(id)object;

- (BSErrorPage *)showNoDataPageOnView:(UIView *)superView;
- (BSErrorPage *)showNoDataPageOnView:(UIView *)superView bellowView:(UIView *)bellowView;

- (void)removeErrorPage;

@end
