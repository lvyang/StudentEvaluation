//
//  BSLoginViewController.m
//  BSResourceModule
//
//  Created by admin zheng on 2017/3/16.
//  Copyright © 2017年 lvyang. All rights reserved.
//

#import "BSLoginViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BSLoginManager.h"
#import "UIColor+Hex.h"
#import "BSSettings.h"
#import "BSWebviewViewController.h"
#import "BSSettings.h"
#import "UIView+LayoutMethods.h"
#import "ForgetPasswordViewController.h"

@interface BSLoginViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *forgetButton;
@property (weak, nonatomic) IBOutlet UIButton *registButton;
@property (weak, nonatomic) IBOutlet UIButton *qqButton;
@property (weak, nonatomic) IBOutlet UIButton *weChatButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leadSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space1;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space3;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space4;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *space5;
@end

@implementation BSLoginViewController

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"综合素质评价教师登录";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationItem.leftBarButtonItem = nil;
    
    // UI
    {
        self.loginButton.layer.cornerRadius = 5;
        self.loginButton.layer.masksToBounds = YES;
        
        // 监控姓名更换头像
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(textFieldTextDidChangeOneCI:)
                                                 name    :UITextFieldTextDidChangeNotification
                                                 object  :_userNameField];
    }
    
    // update layout
    {
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        CGFloat space = screenWidth - self.forgetButton.width - self.registButton.width - self.qqButton.width - self.weChatButton.width;
        space = space - self.leadSpace.constant * 2;
        self.space1.constant = space / 5;
        self.space2.constant = space / 5;
        self.space3.constant = space / 5;
        self.space4.constant = space / 5;
        self.space5.constant = space / 5;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self showLastLoginUserInfo];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)back:(id)sender
{
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showLastLoginUserInfo
{
    NSUserDefaults  *ud = [NSUserDefaults standardUserDefaults];
    NSString        *lastName = [ud objectForKey:@"LastLoginUserName"];
    
    _userNameField.text = [ud objectForKey:@"LastLoginUserName"];
    
    [self getUserIcon:lastName];
}

// 获取头像
- (void)getUserIcon:(NSString *)userName
{
    NSUserDefaults  *ud = [NSUserDefaults standardUserDefaults];
    NSDictionary    *infoDict = [ud objectForKey:@"UsersInfo"];
    UIImage         *placeholderImage = [UIImage imageNamed:@"login_icon_avatar_default.png"];
    NSString        *infoIcon;
    
    if ((infoDict != nil) && (infoDict.count > 0) && [infoDict.allKeys containsObject:userName]) {
        NSDictionary *userInfo = infoDict[userName];
        infoIcon = [userInfo objectForKey:@"user_icon"];
    }
    
    if (infoIcon != nil) {
        [self.icon sd_setImageWithURL:[NSURL URLWithString:infoIcon] placeholderImage:placeholderImage];
    } else {
        self.icon.image = placeholderImage;
    }
}

// 头像可能变换
- (void)textFieldTextDidChangeOneCI:(NSNotification *)notification
{
    UITextField *textfield = [notification object];
    
    [self getUserIcon:[textfield.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]];
}

// 点击登录
- (IBAction)toLogin:(id)sender
{
    NSString *errorMsg = nil;
    if ([self.userNameField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        errorMsg = @"用户名不能为空";
    } else if ([self.userPWField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length == 0) {
        errorMsg = @"密码不能为空";
    }
    
    if (errorMsg) {
        [self showPrompt:errorMsg];
        return;
    }
    
    [self.userPWField resignFirstResponder];
    [self.userNameField resignFirstResponder];
    
    [self login];
}

- (IBAction)tapped:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (void)login
{
    __weak typeof(self) weakSelf = self;
    
    [self showLoadingProgress:nil];
    [[BSLoginManager shareManager] loginWithUserName:self.userNameField.text password:self.userPWField.text completed:^(NSError *error, NSDictionary *response) {
        [self hideLoadingProgress];
        
        __strong typeof(weakSelf) strongSelf = weakSelf;
        
        if (error) {
            [strongSelf showPrompt:@"用户名或密码错误"];
            return ;
        }

        [strongSelf saveCurrentUserInfo:response];
        
        [strongSelf showPrompt:@"登录成功!" HideDelay:2 withCompletionBlock:^{
            [strongSelf back:nil];
            
            NSNotification *notification = [NSNotification notificationWithName:BS_LOGIN_SUCCESS object:nil];
            [[NSNotificationCenter defaultCenter] postNotification:notification];
        }];
    }];
}

// 忘记密码
- (IBAction)retrievePW:(id)sender
{
    ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc] initWithNibName:@"ForgetPasswordViewController" bundle:nil];
    [self.navigationController pushViewController:vc animated:YES];
}

// 登录成功用户名存本地
- (void)saveUsernamelocally
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:_userNameField.text forKey:@"LastLoginUserName"];
    [ud synchronize];
}

- (void)saveCurrentUserInfo:(NSDictionary *)info
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    [ud setObject:info forKey:@"Current_User_Info"];
    [ud synchronize];
    [self saveUsernamelocally];
    [self saveUsersIconInfo:info];
}

- (NSDictionary *)getCurrentUserInfo
{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    
    return [ud objectForKey:@"Current_User_Info"];
}

// 存用户信息于本地，未最终完成
- (void)saveUsersIconInfo:(NSDictionary *)newInfo
{
    NSUserDefaults      *ud = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary *usersInfo = [[NSMutableDictionary alloc] initWithCapacity:0];
    NSDictionary        *oldUsersInfo = [ud objectForKey:@"UsersInfo"];
    
    if (oldUsersInfo != nil) {
        [usersInfo setDictionary:oldUsersInfo];
    }
    
    [usersInfo setObject:@{@"user_icon":[newInfo objectForKey:@"imgurl"]} forKey:_userNameField.text];
    [ud setObject:usersInfo forKey:@"UsersInfo"];
    [ud synchronize];
}

#pragma mark - UITextViewDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@"\n"]) {
        [textField resignFirstResponder];
        return NO;
    }
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    return YES;
}

@end
