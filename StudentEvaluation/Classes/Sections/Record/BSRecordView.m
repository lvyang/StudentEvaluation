//
//  BSRecordView.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/8.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSRecordView.h"
#import "BSAudioRecorder.h"

@interface BSRecordView()<BSAudioRecorderDelegate>

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *pressButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImageView;

@property (nonatomic, strong) BSAudioRecorder *recorder;
@property (nonatomic, assign) BOOL cancelled;
@property (nonatomic, assign) NSTimeInterval duration;

@end


@implementation BSRecordView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.contentView.layer.cornerRadius = 5;
    self.pressButton.layer.cornerRadius = 3;
    
    [self addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - public
- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
}

- (void)hide
{
    [self removeFromSuperview];
}

#pragma mark - private
- (void)startRecord
{
    NSString *fileName = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
    [self.recorder startRecordWithFileName:fileName];
    
    [self.pressButton setTitle:@"松开结束录音" forState:UIControlStateNormal];
    self.pressButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.iconImageView.image = [UIImage imageNamed:@"ic_record.png"];
    self.voiceImageView.hidden = NO;
}

- (void)stopRecord
{
    self.duration = self.recorder.duration;
    [self.recorder stopRecord];
    
    [self.pressButton setTitle:@"按下录音" forState:UIControlStateNormal];
    self.pressButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.iconImageView.image = [UIImage imageNamed:@"ic_record.png"];
    self.voiceImageView.hidden = YES;
}

- (void)readToCancelRecord
{
    [self.pressButton setTitle:@"松开取消发送" forState:UIControlStateNormal];
    self.pressButton.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.4];
    self.iconImageView.image = [UIImage imageNamed:@"ic_release_to_cancel.png"];
    self.voiceImageView.hidden = YES;
}

- (void)resumeRecord
{
    [self.pressButton setTitle:@"松开结束录音" forState:UIControlStateNormal];
    self.pressButton.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
    self.iconImageView.image = [UIImage imageNamed:@"ic_record.png"];
    self.voiceImageView.hidden = NO;
}

- (void)cancelRecord
{
    [self stopRecord];
}

#pragma mark - getter
- (BSAudioRecorder *)recorder
{
    if (!_recorder) {
        _recorder = [[BSAudioRecorder alloc] init];
        _recorder.delegate = self;
    }
    
    return _recorder;
}

#pragma mark - UIButton actions
- (IBAction)touchDown:(id)sender
{
    [self startRecord];
}

- (IBAction)touchCancel:(id)sender
{
    self.cancelled = YES;
    [self stopRecord];
}

- (IBAction)touchDragEnter:(id)sender
{
    [self resumeRecord];
}

- (IBAction)touchDragExit:(id)sender
{
    [self readToCancelRecord];
}

- (IBAction)touchUpInside:(id)sender
{
    self.cancelled = NO;
    [self stopRecord];
}

- (IBAction)touchUpOutside:(id)sender
{
    self.cancelled = YES;
    [self cancelRecord];
}

#pragma mark - BSAudioRecorderDelegate
- (void)recorder:(BSAudioRecorder *)recorder recordFinished:(NSString *)filePath
{
    if (self.cancelled) {
        [[NSFileManager defaultManager] removeItemAtPath:self.recorder.filePath error:nil];
        if ([self.delegate respondsToSelector:@selector(recordView:recordFinished:error:)]) {
            NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:888 userInfo:@{NSLocalizedDescriptionKey : @"取消录音"}];
            [self.delegate recordView:self recordFinished:nil error:error];
            return;
        }
    }
    if (self.duration < 2) {
        [[NSFileManager defaultManager] removeItemAtPath:self.recorder.filePath error:nil];
        if ([self.delegate respondsToSelector:@selector(recordView:recordFinished:error:)]) {
            NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:888 userInfo:@{NSLocalizedDescriptionKey : @"说话时间太短"}];
            [self.delegate recordView:self recordFinished:nil error:error];
            return;
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(recordView:recordFinished:error:)]) {
        [self.delegate recordView:self recordFinished:filePath error:nil];
    }
}


@end
