//
//  MedalRecordDetailViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/13.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "MedalRecordDetailViewController.h"
#import <LYBaseWebView.h>
#import <Masonry.h>
#import "BSSettings.h"

@interface MedalRecordDetailViewController ()

@property (nonatomic, strong) UIWebView *webView;

@end

@implementation MedalRecordDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"勋章详情";

    // web view
    {
        self.webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.webView];
        [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[self contentUrl]];
    [self.webView loadRequest:request];
}

- (NSURL *)contentUrl
{
    NSString *baseUrl = [BSSettings baseUrl];
    NSString *urlString = [NSString stringWithFormat:@"%@appapi/wapPage/medal/detail?awardMedalId=%@",baseUrl,self.medalRecordId];
    return  [NSURL URLWithString:urlString ? : @""];
}

@end
