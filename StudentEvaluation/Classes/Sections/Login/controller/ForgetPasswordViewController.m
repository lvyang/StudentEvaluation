//
//  ForgetPasswordViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "NetworkManager.h"
#import "BSStringUtil.h"
#import "ChangePasswordViewController.h"

@interface ForgetPasswordViewController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;
@property (weak, nonatomic) IBOutlet UIButton *verificaitonCodeButton;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) NSString *verifyCode;

@end

@implementation ForgetPasswordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"忘记密码";
    
    self.phoneNumberTextField.delegate = self;
    self.verifyTextField.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

- (IBAction)verify:(UIButton *)sender
{
    if (self.phoneNumberTextField.text.length == 0) {
        [self showPrompt:@"请输入手机号"];
        return;
    }
    
    if (![BSStringUtil isValidatePhoneNumber:self.phoneNumberTextField.text]) {
        [self showPrompt:@"电话号码格式不正确"];
        return;
    }
    
    sender.enabled = NO;
    [self startCountDown];
    
    [NetworkManager getVerficationCode:self.phoneNumberTextField.text userId:nil completed:^(NSError *error, NSString *code) {
        if (error) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        self.verifyCode = code;
    }];
}

- (void)startCountDown
{
    [self.timer invalidate];
    self.timer = nil;
    
    self.count = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(minusCount) userInfo:nil repeats:YES];
    [self.timer fire];
    self.verificaitonCodeButton.enabled = NO;
}

- (void)minusCount
{
    _count--;
    if (_count == 0) {
        [self.timer invalidate];
        self.timer = nil;
        
        [self.verificaitonCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.verificaitonCodeButton.backgroundColor = [UIColor colorWithHexString:@"54BFCA"];
        [self.verificaitonCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.verificaitonCodeButton.enabled = YES;
    } else {
        [self.verificaitonCodeButton setTitle:[NSString stringWithFormat:@"%lds",(long)_count] forState:UIControlStateNormal];

        self.verificaitonCodeButton.backgroundColor = [UIColor colorWithHexString:@"ECECEC"];
        [self.verificaitonCodeButton setTitleColor:[UIColor colorWithHexString:@"696969"] forState:UIControlStateNormal];
    }
}

- (IBAction)next:(id)sender
{
    if (self.verifyTextField.text.length == 0) {
        [self showPrompt:@"请填写验证码!"];
        return;
    }
    
    if (![self.verifyTextField.text isEqualToString:self.verifyCode]) {
        [self showPrompt:@"验证码错误!"];
        return;
    }
    
    ChangePasswordViewController *vc = [[ChangePasswordViewController alloc] initWithNibName:@"ChangePasswordViewController" bundle:nil];
    vc.phone = self.phoneNumberTextField.text;
    vc.verifyCode = self.verifyTextField.text;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)tapped:(id)sender
{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
