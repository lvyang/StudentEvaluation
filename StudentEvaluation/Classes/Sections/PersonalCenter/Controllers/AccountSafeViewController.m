//
//  AccountSafeViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "AccountSafeViewController.h"
#import "BindingPhoneViewController.h"
#import "ChangePasswordViewController.h"

@interface AccountSafeViewController ()

@end

@implementation AccountSafeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"账号安全";
}

- (IBAction)bindPhone:(id)sender
{
    BindingPhoneViewController *vc = [[BindingPhoneViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)changePassword:(id)sender
{
    ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
