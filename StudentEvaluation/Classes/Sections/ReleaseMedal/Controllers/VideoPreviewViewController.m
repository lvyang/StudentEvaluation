//
//  VideoPreviewViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/9.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "VideoPreviewViewController.h"
#import "SCPlayer.h"
#import "SCVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

@interface VideoPreviewViewController ()

@property (weak, nonatomic) IBOutlet UIButton *backButton;

@property (nonatomic, strong) SCPlayer *player;

@end

@implementation VideoPreviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES animated:YES];

    _player = [SCPlayer player];
    _player.loopEnabled = YES;
    [_player setItemByUrl:self.url];

    SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerView.frame = self.view.bounds;
    [self.view insertSubview:playerView belowSubview:self.backButton];
    [playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).with.offset(0);
        make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
        make.left.equalTo(self.view.mas_left).with.offset(0);
        make.right.equalTo(self.view.mas_right).with.offset(0);
    }];

    [_player play];
}

- (IBAction)back:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
