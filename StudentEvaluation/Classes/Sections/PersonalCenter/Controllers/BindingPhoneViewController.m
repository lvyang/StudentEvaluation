//
//  BindingPhoneViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BindingPhoneViewController.h"
#import "BSLoginManager.h"
#import "BSStringUtil.h"
#import "NetworkManager.h"

@interface BindingPhoneViewController ()

@property (weak, nonatomic) IBOutlet UILabel *bindedPhoneLabel;
@property (weak, nonatomic) IBOutlet UITextField *bindingPhoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *verifyTextField;

@property (weak, nonatomic) IBOutlet UIButton *changeButton;
@property (weak, nonatomic) IBOutlet UIButton *sendCodeButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changePhoneBackgroundHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *currentPhoneLabelHeight;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) NSString *verifyCode;

@end

@implementation BindingPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"绑定手机";
    
    self.changeButton.layer.borderWidth = 1;
    self.changeButton.layer.borderColor = [UIColor colorWithHexString:@"868686"].CGColor;
    self.changeButton.layer.cornerRadius = 5;
    self.changeButton.layer.masksToBounds = YES;
    
    self.sendCodeButton.layer.cornerRadius = 5;
    self.sendCodeButton.layer.masksToBounds = YES;

    self.confirmButton.layer.cornerRadius = 5;
    self.confirmButton.layer.masksToBounds = YES;
    
    NSString *phone = [BSLoginManager shareManager].userModel.phone;
    if (phone.length) {
        self.currentPhoneLabelHeight.constant = 50;
        self.bindedPhoneLabel.text = [NSString stringWithFormat:@"已绑定手机: %@",[BSStringUtil encriptPhoneNumber: phone]];
        self.changePhoneBackgroundHeight.constant = 0;
    } else {
        self.currentPhoneLabelHeight.constant = 0;
        self.bindedPhoneLabel.text = nil;
        self.changePhoneBackgroundHeight.constant = 223;
    }
}

- (IBAction)changePhoneNumber:(id)sender
{
    if (self.changePhoneBackgroundHeight.constant == 0) {
        self.changePhoneBackgroundHeight.constant = 223;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view setNeedsLayout];
        }];
    }
}

- (IBAction)sendCode:(UIButton *)sender
{
    if (self.bindingPhoneTextField.text.length == 0) {
        [self showPrompt:@"请输入手机号"];
        return;
    }
    
    if (![BSStringUtil isValidatePhoneNumber:self.bindingPhoneTextField.text]) {
        [self showPrompt:@"电话号码格式不正确"];
        return;
    }
    
    sender.enabled = NO;
    [self startCountDown];
    
    NSString *userId = [BSLoginManager shareManager].userModel.userId;
    [NetworkManager getVerficationCode:self.bindingPhoneTextField.text userId:userId completed:^(NSError *error, NSString *code) {
        if (error) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        self.verifyCode = code;
    }];
}

- (IBAction)confirm:(id)sender
{
    if (self.verifyTextField.text.length == 0) {
        [self showPrompt:@"请填写验证码!"];
        return;
    }
    
    if (![self.verifyTextField.text isEqualToString:self.verifyCode]) {
        [self showPrompt:@"验证码错误!"];
        return;
    }

    NSString *userId = [BSLoginManager shareManager].userModel.userId;
    [NetworkManager bindPhone:self.bindingPhoneTextField.text identifyCode:self.verifyTextField.text userId:userId completed:^(NSError *error) {
        if (error) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        BSUserModel *model = [BSLoginManager shareManager].userModel;
        model.phone = self.bindingPhoneTextField.text;
        [[BSLoginManager shareManager] updateCurrentUser:model];
        
        [self showPrompt:@"绑定成功!" HideDelay:2 withCompletionBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }];
}

- (void)startCountDown
{
    [self.timer invalidate];
    self.timer = nil;
    
    self.count = 60;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(minusCount) userInfo:nil repeats:YES];
    [self.timer fire];
    self.sendCodeButton.enabled = NO;
}

- (void)minusCount
{
    _count--;
    if (_count == 0) {
        [self.timer invalidate];
        self.timer = nil;
        
        [self.sendCodeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
        self.sendCodeButton.backgroundColor = [UIColor colorWithHexString:@"54BFCA"];
        [self.sendCodeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.sendCodeButton.enabled = YES;
    } else {
        [self.sendCodeButton setTitle:[NSString stringWithFormat:@"%lds",(long)_count] forState:UIControlStateNormal];
        
        self.sendCodeButton.backgroundColor = [UIColor colorWithHexString:@"ECECEC"];
        [self.sendCodeButton setTitleColor:[UIColor colorWithHexString:@"696969"] forState:UIControlStateNormal];
    }
}

@end
