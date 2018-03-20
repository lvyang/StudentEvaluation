//
//  ChangePasswordViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/20.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "NetworkManager.h"
#import "BSLoginManager.h"
#import "UIView+Additional.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *originalPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confrimPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *passwordVisibleButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"修改密码";
    
    UIColor *color = [UIColor colorWithRed:86/255.0 green:191/255.0 blue:204/255.0 alpha:1];
    [self.originalPasswordTextField addBorderOnDirections:BorderDirectionsBottom width:0.5 color:color];
    [self.passwordTextField addBorderOnDirections:BorderDirectionsBottom width:0.5 color:color];
    [self.confrimPasswordTextField addBorderOnDirections:BorderDirectionsBottom width:0.5 color:color];
    
    self.originalPasswordTextField.delegate = self;
    self.passwordTextField.delegate = self;
    self.confrimPasswordTextField.delegate = self;
    
    self.confirmButton.layer.cornerRadius = 5;
    self.confirmButton.layer.masksToBounds = YES;
    
    [self passwordVisible:self.passwordVisibleButton.selected];
}

- (void)passwordVisible:(BOOL)visible
{
    self.originalPasswordTextField.secureTextEntry = !visible;
    self.passwordTextField.secureTextEntry = !visible;
    self.confrimPasswordTextField.secureTextEntry = !visible;
}

- (IBAction)secrectPassword:(UIButton *)sender
{
    sender.selected = !sender.selected;
    [self passwordVisible:sender.selected];
}

- (IBAction)confirm:(id)sender
{
    if (self.originalPasswordTextField.text.length == 0) {
        [self showPrompt:@"原始密码不能为空"];
        return;
    }
    
    if (self.passwordTextField.text.length == 0) {
        [self showPrompt:@"新密码不能为空"];
        return;
    }
    
    if (self.confrimPasswordTextField.text.length == 0) {
        [self showPrompt:@"确认密码不能为空"];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.confrimPasswordTextField.text]) {
        [self showPrompt:@"再次输入密码与新密码不一致"];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    BSUserModel *user = [BSLoginManager shareManager].userModel;
    [NetworkManager changePasswordForUser:user.userName passowrd:self.passwordTextField.text oldPassword:self.originalPasswordTextField.text completed:^(NSError *error) {
        if (error) {
            [weakSelf showPrompt:error.localizedDescription];
            return ;
        }
        
        [weakSelf showPrompt:@"密码修改成功" HideDelay:2 withCompletionBlock:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (IBAction)tap:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
    return YES;
}

@end
