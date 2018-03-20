//
//  NoticeAlertViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/20.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "NoticeAlertViewController.h"

@interface NoticeAlertViewController ()

@property (weak, nonatomic) IBOutlet UISwitch *systemNoticeOpenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *voiceOpenSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *shakeOpenSwitch;

@end

@implementation NoticeAlertViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.systemNoticeOpenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"systemNoticeOpen"];
    self.voiceOpenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"voiceOpen"];
    self.shakeOpenSwitch.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"shakeOpen"];
}


- (IBAction)systemNoticeOpen:(UISwitch *)sender
{
    sender.on = !sender.on;
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"systemNoticeOpen"];
}

- (IBAction)voiceOpen:(UISwitch *)sender
{
    sender.on = !sender.on;
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"voiceOpen"];
}

- (IBAction)shakeOpen:(UISwitch *)sender
{
    sender.on = !sender.on;
    [[NSUserDefaults standardUserDefaults] setBool:sender.on forKey:@"shakeOpen"];
}

@end
