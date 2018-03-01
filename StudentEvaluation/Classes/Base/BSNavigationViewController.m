//
//  BSNavigationViewController.m
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/9/22.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "BSNavigationViewController.h"
#import "UIColor+Hex.h"
#import "UIImage+ImageAddition.h"

@interface BSNavigationViewController ()

@end

@implementation BSNavigationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self customNavigationBarUI];
}

- (void)customNavigationBarUI
{
    [self.navigationBar setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"54bfca"]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
                                NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationBar setTitleTextAttributes:attribute];
}

@end
