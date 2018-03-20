//
//  SettingsViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "SettingsViewController.h"
#import "BSLoginManager.h"
#import "AccountSafeViewController.h"
#import "NoticeAlertViewController.h"

@interface SettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置";

    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appVersion = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    self.versionLabel.text = [NSString stringWithFormat:@"V%@",appVersion];
    
    self.logoutButton.layer.cornerRadius = 5;
    self.logoutButton.layer.borderWidth = 1;
    self.logoutButton.layer.borderColor = [UIColor colorWithRed:86/255.0 green:190/255.0 blue:204/255.0 alpha:1].CGColor;
}

- (IBAction)accountSafe:(id)sender
{
    AccountSafeViewController *vc = [[AccountSafeViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)notice:(id)sender
{
    NoticeAlertViewController *vc = [[NoticeAlertViewController alloc] initWithNibName:nil bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)currentVersion:(id)sender
{
    
}

- (IBAction)logout:(id)sender
{
    [[BSLoginManager shareManager] removerCurrentUserInfo];
    [[NSNotificationCenter defaultCenter] postNotificationName:BS_LOGOUT_SUCCESS object:nil];
}
@end
