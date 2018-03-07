//
//  WechatShortVideoController.m
//  SCRecorderPack
//
//  Created by AliThink on 15/8/17.
//  Copyright (c) 2015年 AliThink. All rights reserved.
//

// This code is distributed under the terms and conditions of the MIT license.

// Copyright (c) 2015 AliThink
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "WechatShortVideoController.h"
#import "SCRecorder.h"
#import "SCRecordSessionManager.h"
#import "MBProgressHUD.h"
#import "ProgressView.h"


@interface WechatShortVideoController () <SCRecorderDelegate, SCAssetExportSessionDelegate, MBProgressHUDDelegate>
@property (weak, nonatomic) IBOutlet UIView *scanPreviewView;
@property (weak, nonatomic) IBOutlet UIButton *captureRealBtn;
@property (strong, nonatomic) SCRecorderToolsView *focusView;
@property (strong, nonatomic) NSTimer *exportProgressBarTimer;
@property (strong, nonatomic) MBProgressHUD *progressHUD;

@property (weak, nonatomic) IBOutlet ProgressView *pressButtonBackgroundView;
@property (weak, nonatomic) IBOutlet UIView *pressButtonView;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *cancelButtonCenterX;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmButtonCenterX;

@end

@implementation WechatShortVideoController {
    BOOL captureValidFlag;
    SCRecorder *_recorder;
    SCRecordSession *_recordSession;
    NSTimer *longPressTimer;
    
    //Preview
    SCPlayer *_player;
    
    //Video filepath
    NSURL *VIDEO_OUTPUTFILE;
}

@synthesize delegate;

#pragma mark - Do Next Func
- (void)doNextWhenVideoSavedSuccess {
    //file path is VIDEO_OUTPUTFILE
    
}

- (IBAction)closeAction:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    VIDEO_OUTPUTFILE = [NSURL fileURLWithPath:[PATH_OF_DOCUMENT stringByAppendingPathComponent:VIDEO_DEFAULTNAME]];
    
    captureValidFlag = NO;
    
    [self configRecorder];
    
    self.pressButtonView.layer.cornerRadius = self.pressButtonView.frame.size.width / 2;
    self.pressButtonView.layer.masksToBounds = YES;
    self.pressButtonBackgroundView.layer.cornerRadius = self.pressButtonBackgroundView.frame.size.width / 2;
    self.pressButtonBackgroundView.layer.masksToBounds = YES;
    
    self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.width / 2;
    self.cancelButton.layer.masksToBounds = YES;
    self.cancelButton.alpha = 0;
    self.confirmButton.layer.cornerRadius = self.confirmButton.frame.size.width / 2;
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.alpha = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self prepareSession];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [_recorder previewViewFrameChanged];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_recorder startRunning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_recorder stopRunning];
}

- (void)dealloc {
    _recorder.previewView = nil;
    [_player pause];
    _player = nil;
}


#pragma mark - View Config
- (void)configRecorder {
    _recorder = [SCRecorder recorder];
    _recorder.captureSessionPreset = [SCRecorderTools bestCaptureSessionPresetCompatibleWithAllDevices];
    _recorder.maxRecordDuration = CMTimeMake(30 * VIDEO_MAX_TIME, 30);
    _recorder.delegate = self;
    _recorder.autoSetVideoOrientation = YES;
    
    UIView *previewView = self.scanPreviewView;
    _recorder.previewView = previewView;
    
    self.focusView = [[SCRecorderToolsView alloc] initWithFrame:previewView.bounds];
    self.focusView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
    self.focusView.recorder = _recorder;
    [previewView addSubview:self.focusView];
    
    self.focusView.outsideFocusTargetImage = [UIImage imageNamed:@"WechatShortVideo_scan_focus"];
    _recorder.initializeSessionLazily = NO;
    
    NSError *error;
    if (![_recorder prepare:&error]) {
        NSLog(@"Prepare error: %@", error.localizedDescription);
    }
}

- (void)prepareSession {
    if (_recorder.session == nil) {
        
        SCRecordSession *session = [SCRecordSession recordSession];
        session.fileType = AVFileTypeQuickTimeMovie;
        
        _recorder.session = session;
    }
}

- (void)refreshProgressViewLengthByTime:(CMTime)duration {
    CGFloat durationTime = CMTimeGetSeconds(duration);
    self.pressButtonBackgroundView.percent = durationTime / VIDEO_MAX_TIME;
}

- (void)prepareToRecord
{
    self.cancelButton.alpha = 0;
    self.confirmButton.alpha = 0;
    self.cancelButtonCenterX.constant = 0;
    self.confirmButtonCenterX.constant = 0;
    
    self.pressButtonBackgroundView.hidden = NO;
    self.pressButtonView.hidden = NO;
    self.captureRealBtn.hidden = NO;
    
    self.pressButtonBackgroundView.percent = 0;
}

- (void)whenStartRecord
{    
    [UIView animateWithDuration:0.2 animations:^{
        self.pressButtonBackgroundView.transform = CGAffineTransformMakeScale(1.4, 1.4);
        self.pressButtonView.transform = CGAffineTransformMakeScale(0.8, 0.8);
    } completion:nil];
}

- (void)whenStopRecord
{
    self.pressButtonBackgroundView.hidden = YES;
    self.pressButtonView.hidden = YES;
    self.captureRealBtn.hidden = YES;
    self.pressButtonBackgroundView.transform = CGAffineTransformIdentity;
    self.pressButtonView.transform = CGAffineTransformIdentity;
    self.pressButtonBackgroundView.percent = 0;

    self.cancelButton.alpha = 1;
    self.confirmButton.alpha = 1;
    self.cancelButtonCenterX.constant = -([UIScreen mainScreen].bounds.size.width / 4);
    self.confirmButtonCenterX.constant = ([UIScreen mainScreen].bounds.size.width / 4);

    [UIView animateWithDuration:0.2 animations:^{
        [self.view layoutIfNeeded];
    } completion:nil];
}

- (IBAction)recordCancel:(id)sender
{
    [self prepareToRecord];
    [self removePreviewMode];
}

- (IBAction)recordConfirm:(id)sender
{
    [self saveCapture];
    [self prepareToRecord];
}

- (IBAction)cameraToggled:(id)sender
{
    [_recorder switchCaptureDevices];
}

- (void)captureSuccess {
    captureValidFlag = YES;
}

- (void)cancelCaptureWithSaveFlag:(BOOL)saveFlag {
    [_recorder pause:^{
        if (saveFlag) {
            //Preview and save
            [self configPreviewMode];
        } else {
            //retake prepare
            SCRecordSession *recordSession = _recorder.session;
            if (recordSession != nil) {
                _recorder.session = nil;
                if ([[SCRecordSessionManager sharedInstance] isSaved:recordSession]) {
                    [recordSession endSegmentWithInfo:nil completionHandler:nil];
                } else {
                    [recordSession cancelSession:nil];
                }
            }
            [self prepareSession];
        }
    }];
}

#pragma mark - Record finish Preview and save
- (void)configPreviewMode {
    if ([self.scanPreviewView viewWithTag:400]) {
        return;
    }
    
    self.captureRealBtn.enabled = NO;
    
    _player = [SCPlayer player];
    SCVideoPlayerView *playerView = [[SCVideoPlayerView alloc] initWithPlayer:_player];
    playerView.tag = 400;
    playerView.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    playerView.frame = self.scanPreviewView.bounds;
    playerView.autoresizingMask = self.scanPreviewView.autoresizingMask;
    [self.scanPreviewView addSubview:playerView];
    _player.loopEnabled = YES;
    
    [_player setItemByAsset:_recorder.session.assetRepresentingSegments];
    [_player play];
}

- (void)removePreviewMode {
    self.captureRealBtn.enabled = YES;
    [_player pause];
    _player = nil;
    for (UIView *subview in self.scanPreviewView.subviews) {
        if (subview.tag == 400) {
            [subview removeFromSuperview];
        }
    }
    
    [self cancelCaptureWithSaveFlag:NO];
}

- (void)saveCapture {
    [_player pause];
    
    void(^completionHandler)(NSURL *url, NSError *error) = ^(NSURL *url, NSError *error) {
        if (error == nil) {
            [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
            UISaveVideoAtPathToSavedPhotosAlbum(url.path, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        } else {
            self.progressHUD.labelText = [NSString stringWithFormat:@"Failed to save\n%@", error.localizedDescription];
            self.progressHUD.mode = MBProgressHUDModeCustomView;
            [self.progressHUD hide:YES afterDelay:3];
        }
    };
    
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    
    SCAssetExportSession *exportSession = [[SCAssetExportSession alloc] initWithAsset:_recorder.session.assetRepresentingSegments];
    exportSession.videoConfiguration.preset = SCPresetHighestQuality;
    exportSession.audioConfiguration.preset = SCPresetHighestQuality;
    exportSession.videoConfiguration.maxFrameRate = 35;
    exportSession.outputUrl = VIDEO_OUTPUTFILE;
    exportSession.outputFileType = AVFileTypeMPEG4;
    exportSession.delegate = self;
    
    self.progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    self.progressHUD.delegate = self;
    self.progressHUD.mode = MBProgressHUDModeDeterminate;
    
    CFTimeInterval time = CACurrentMediaTime();
    [exportSession exportAsynchronouslyWithCompletionHandler:^{
        [_player play];
        
        NSLog(@"Completed compression in %fs", CACurrentMediaTime() - time);
        
        [[UIApplication sharedApplication] endIgnoringInteractionEvents];
        
        completionHandler(exportSession.outputUrl, exportSession.error);
    }];
}

#pragma mark - MBProgressHUDDelegate

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [hud removeFromSuperview];
    hud = nil;
}

#pragma mark - SCRecorderDelegate
- (void)recorder:(SCRecorder *)recorder didAppendVideoSampleBufferInSession:(SCRecordSession *)recordSession {
    //update progressBar
    [self refreshProgressViewLengthByTime:recordSession.duration];
}

- (void)recorder:(SCRecorder *__nonnull)recorder didCompleteSession:(SCRecordSession *__nonnull)session {
    //confirm capture
    if (captureValidFlag) {
        //preview and save video
        [self cancelCaptureWithSaveFlag:YES];
    } else {
        [self cancelCaptureWithSaveFlag:NO];
    }
    
    [self whenStopRecord];
}

- (void)video:(NSString *)videoPath didFinishSavingWithError:(NSError *)error contextInfo: (void *) contextInfo {
    [[UIApplication sharedApplication] endIgnoringInteractionEvents];
    
    if (error == nil) {
        self.progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"WechatShortVideo_37x-Checkmark.png"]];
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        [self.progressHUD hide:YES afterDelay:1];

        //return the filepath
        [self removePreviewMode];
        [self doNextWhenVideoSavedSuccess];
        
        if ([delegate respondsToSelector:@selector(finishWechatShortVideoCapture:)]) {
            [delegate finishWechatShortVideoCapture:VIDEO_OUTPUTFILE];
        }
        
        if (self.didFinishRecordHandle) {
            NSURL *url = [NSURL fileURLWithPath:videoPath ? : @""];
            self.didFinishRecordHandle(error, url);
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    } else {
        self.progressHUD.labelText = [NSString stringWithFormat:@"Failed to save\n%@", error.localizedDescription];
        self.progressHUD.mode = MBProgressHUDModeCustomView;
        [self.progressHUD hide:YES afterDelay:3];
    }
}

#pragma mark - SCAssetExportSessionDelegate
- (void)assetExportSessionDidProgress:(SCAssetExportSession *)assetExportSession {
    dispatch_async(dispatch_get_main_queue(), ^{
        float progress = assetExportSession.progress;
        self.progressHUD.progress = progress;
    });
}

#pragma mark - Center Record Btn ActionEvent
- (IBAction)captureStartTouchUpInside:(UIButton *)captureBtn {
    //confirm capture
    [self whenStopRecord];
    if (captureValidFlag) {
        //preview and save video
        [self cancelCaptureWithSaveFlag:YES];
    } else {
        [self cancelCaptureWithSaveFlag:NO];
    }
}

- (IBAction)captureStartTouchUpOutside:(UIButton *)captureBtn {
    [self cancelCaptureWithSaveFlag:YES];
    [self whenStopRecord];
}

- (IBAction)captureStartTouchDownAction:(UIButton *)captureBtn {
    captureValidFlag = NO;
    if (longPressTimer) {
        [longPressTimer invalidate];
        longPressTimer = nil;
    }
    longPressTimer = [NSTimer scheduledTimerWithTimeInterval:VIDEO_VALID_MINTIME target:self selector:@selector(captureSuccess) userInfo:nil repeats:NO];
    
    [_recorder record];
    [self whenStartRecord];
}

@end
