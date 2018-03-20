//
//  ChangePasswordViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ResetPasswordViewController.h"
#import "NetworkManager.h"

@interface ResetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

@end

@implementation ResetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"重设密码";
    
    self.passwordTextField.delegate = self;
    self.confirmPasswordTextField.delegate = self;
}

- (IBAction)tap:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

- (IBAction)confirm:(id)sender
{
    if (self.passwordTextField.text.length == 0) {
        [self showPrompt:@"新密码不能为空"];
        return;
    }
    
    if (self.confirmPasswordTextField.text.length == 0) {
        [self showPrompt:@"确认密码不能为空"];
        return;
    }
    
    if (![self.passwordTextField.text isEqualToString:self.confirmPasswordTextField.text]) {
        [self showPrompt:@"再次输入密码与新密码不一致"];
        return;
    }
    
    [self showLoadingProgress:nil];
    [NetworkManager resetPassword:self.confirmPasswordTextField.text verifyCode:self.verifyCode phone:self.phone completed:^(NSError *error) {
        [self hideLoadingProgress];
        
        if (error) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        [self showPrompt:@"修改成功" HideDelay:2 withCompletionBlock:^{
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
