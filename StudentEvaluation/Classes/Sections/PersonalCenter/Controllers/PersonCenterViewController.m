//
//  PersonCenterViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/2/28.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "PersonCenterViewController.h"
#import <UIImageView+WebCache.h>
#import "BSLoginManager.h"
#import "BSStringUtil.h"
#import "NetworkManager.h"
#import "NoticeListViewController.h"
#import "SettingsViewController.h"
#import "DataManager.h"
#import "QRCodeViewController.h"
#import "ClassListViewController.h"
#import "UIImage+ImageAddition.h"

@interface PersonCenterViewController ()<QRCodeViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNamerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;

@property (weak, nonatomic) IBOutlet UILabel *noticeCountLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userNameLabelWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *noticeCountLabelWidth;

@end

@implementation PersonCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"个人中心";
    
    UIImage *image = [UIImage imageNamed:@"login_icon_avatar_default.png"];
    NSString *userIcon = [BSLoginManager shareManager].userModel.userIcon;
    NSURL *url = [NSURL URLWithString:userIcon ? : @""];
    [self.iconImageView sd_setImageWithURL:url placeholderImage:image];
    
    self.userNamerLabel.text = [BSLoginManager shareManager].userModel.nickName;
    self.userNameLabelWidth.constant = [BSStringUtil sizeForString:self.userNamerLabel.text font:self.userNamerLabel.font limitWidth:0].width +5;
    
    self.noticeCountLabel.layer.cornerRadius = 3;
    self.noticeCountLabel.layer.masksToBounds = YES;
    
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedClassChanged:) name:SELECTED_CLASS_CHANGED object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageFromColor:[UIColor colorWithHexString:@"54bfca"]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:18],
                                NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationController.navigationBar setTitleTextAttributes:attribute];
    
    [self loadNoticeCount];
}

- (void)loadNoticeCount
{
    NSString *userId = [BSLoginManager shareManager].userModel.userId;
    [NetworkManager loadUnreadNotice:userId completed:^(NSError *error, NSNumber *result) {
        if (!result || result.integerValue == 0) {
            self.noticeCountLabelWidth.constant = 0;
            return ;
        }
        
        self.noticeCountLabel.text = result.stringValue;
        self.noticeCountLabelWidth.constant = [BSStringUtil sizeForString:self.noticeCountLabel.text font:self.noticeCountLabel.font limitWidth:0].width + 15;
    }];
}

- (IBAction)noticeList:(id)sender
{
    NoticeListViewController *vc = [[NoticeListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)settings:(id)sender
{
    SettingsViewController *vc = [[SettingsViewController alloc] initWithNibName:nil bundle:nil];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
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
