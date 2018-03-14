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

@interface PersonCenterViewController ()

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
    
    UIImage *image = [UIImage imageNamed:@"login_icon_avatar_default.png"];
    NSString *userIcon = [BSLoginManager shareManager].userModel.userIcon;
    NSURL *url = [NSURL URLWithString:userIcon ? : @""];
    [self.iconImageView sd_setImageWithURL:url placeholderImage:image];
    
    self.userNamerLabel.text = [BSLoginManager shareManager].userModel.nickName;
    self.userNameLabelWidth.constant = [BSStringUtil sizeForString:self.userNamerLabel.text font:self.userNamerLabel.font limitWidth:0].width +5;
    
    self.noticeCountLabel.layer.cornerRadius = 3;
    self.noticeCountLabel.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
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
    
}

- (IBAction)settings:(id)sender
{
    
}
@end
