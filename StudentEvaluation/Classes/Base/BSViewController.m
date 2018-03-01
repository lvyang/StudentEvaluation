//
//  BSViewController.m
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/9/23.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "BSViewController.h"

@interface BSViewController ()
{
    BSErrorPage *_errorPage;
    UIButton    *_backButton;
}

@end

@implementation BSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self addBackButtonItem];
}

- (void)back:(id)sender
{
    if (!self.navigationController) {
        [self dismissViewControllerAnimated:YES completion:nil];
        return;
    }
    
    if (self.navigationController.viewControllers.count == 1) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addBackButtonItem
{
    _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _backButton.frame = CGRectMake(0, 0, 60, 30);
    [_backButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_backButton setImage:[UIImage imageNamed:@"arrow_back_w.png"] forState:UIControlStateNormal];
    [_backButton setImageEdgeInsets:UIEdgeInsetsMake(0, -45, 0, 0)];
    [_backButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *back = [[UIBarButtonItem alloc] initWithCustomView:_backButton];
    self.navigationItem.leftBarButtonItem = back;
}

- (void)removeBackButtonItem
{
    _backButton.hidden = YES;
    _backButton.enabled = YES;
}

#pragma mark - getter
- (BSErrorPage *)errorPage
{
    if (!_errorPage) {
        _errorPage = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([BSErrorPage class]) owner:nil options:nil][0];
    }
    
    return _errorPage;
}

#pragma mark - error page
- (BSErrorPage *)showErrorPageOnView:(UIView *)superView target:(id)target selector:(SEL)selector object:(id)object
{
    self.errorPage.type = BSErrorPageTypeDownloadError;
    [self.errorPage addReloadTarget:target selector:selector object:object];
    [superView addSubview:self.errorPage];
    
    [self.errorPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(0);
        make.bottom.equalTo(superView.mas_bottom).with.offset(0);
        make.left.equalTo(superView.mas_left).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(0);
    }];
    
    return self.errorPage;
}

- (BSErrorPage *)showErrorPageOnView:(UIView *)superView belowView:(UIView *)bellowView target:(id)target selector:(SEL)selector object:(id)object
{
    self.errorPage.type = BSErrorPageTypeDownloadError;
    [self.errorPage addReloadTarget:target selector:selector object:object];
    [superView insertSubview:self.errorPage belowSubview:bellowView];
    
    [self.errorPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(0);
        make.bottom.equalTo(superView.mas_bottom).with.offset(0);
        make.left.equalTo(superView.mas_left).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(0);
    }];
    
    return self.errorPage;
}

- (BSErrorPage *)showNoDataPageOnView:(UIView *)superView
{
    self.errorPage.type = BSErrorPageTypeNoData;
    [superView addSubview:self.errorPage];
    
    [self.errorPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(0);
        make.bottom.equalTo(superView.mas_bottom).with.offset(0);
        make.left.equalTo(superView.mas_left).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(0);
    }];
    
    return self.errorPage;
}

- (BSErrorPage *)showNoDataPageOnView:(UIView *)superView bellowView:(UIView *)bellowView
{
    self.errorPage.type = BSErrorPageTypeNoData;
    [superView insertSubview:self.errorPage belowSubview:bellowView];
    
    [self.errorPage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(superView.mas_top).with.offset(0);
        make.bottom.equalTo(superView.mas_bottom).with.offset(0);
        make.left.equalTo(superView.mas_left).with.offset(0);
        make.right.equalTo(superView.mas_right).with.offset(0);
    }];
    
    return self.errorPage;
}

- (void)removeErrorPage
{
    [self.errorPage removeFromSuperview];
    _errorPage = nil;
}

@end
