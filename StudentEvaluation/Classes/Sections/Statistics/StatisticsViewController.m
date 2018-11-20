//
//  StatisticsViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/11/20.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "StatisticsViewController.h"
#import "QRCodeViewController.h"
#import "ClassListViewController.h"
#import "DataManager.h"
#import "BSLoginManager.h"

@interface StatisticsViewController ()<QRCodeViewControllerDelegate>

@property (nonatomic, strong) UIWebView *webview;

@end

@implementation StatisticsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"班级情况";
    
    // add bar button item
    {
        UIImage *image = [[UIImage imageNamed:@"class_icon_sweep_nor.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:self action:@selector(scan:)];
        self.navigationItem.leftBarButtonItem = leftItem;
        NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                    NSForegroundColorAttributeName : [UIColor whiteColor]};
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attribute forState:UIControlStateNormal];
        
        [self addRightBarButtonItem];
    }
    
    {
        self.webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.webview];
        self.webview.scalesPageToFit = YES;
        [self.webview mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
        
        NSString *urlString = @"https://www.baidu.com";
        NSURL *url = [NSURL URLWithString:urlString];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [self.webview loadRequest:request];
    }
}

- (void)addRightBarButtonItem
{
    NSString *className = [DataManager shareManager].currentClass.className;
    if (!className) {
        className = @"选择班级";
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:className style:UIBarButtonItemStylePlain target:self action:@selector(classList)];
    self.navigationItem.rightBarButtonItem = rightItem;
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attribute forState:UIControlStateNormal];
}

- (void)scan:(id)sender
{
    QRCodeViewController *vc = [[QRCodeViewController alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    vc.delegate = self;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectedClassChanged:(NSNotification *)notification
{
    [self addRightBarButtonItem];
}

- (void)classList
{
    ClassListViewController *vc = [[ClassListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - QRCodeViewControllerDelegate
- (void)didScanCode:(NSString *)code
{
    NSString *userId = [BSLoginManager shareManager].userModel.userId;
    [NetworkManager scanQrCode:code userId:userId completed:^(NSError *error) {
        if (error) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        [self showPrompt:@"调用扫码成功"];
    }];
}

@end
