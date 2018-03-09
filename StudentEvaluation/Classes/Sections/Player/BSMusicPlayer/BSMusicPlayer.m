//
//  BSMusicPlayer.m
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/10/9.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "BSMusicPlayer.h"
#import <AVFoundation/AVFoundation.h>
#import <DOUAudioPlaybackItem.h>
#import <DOUAudioFileProvider.h>

static void *kStatusKVOKey = &kStatusKVOKey;
static void *kDurationKVOKey = &kDurationKVOKey;
static void *kBufferingRatioKVOKey = &kBufferingRatioKVOKey;

@interface BSMusicPlayer ()
{
    DOUAudioStreamer *_streamer;

    NSUInteger _currentTrackIndex;
}

@property (nonatomic, strong) NSMutableArray *tracks;

@end

@implementation BSMusicPlayer

- (id)init
{
    if (self = [super init]) {
        self.tracks = [NSMutableArray array];
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(routeChange:) name:AVAudioSessionRouteChangeNotification object:nil];
    }

    return self;
}

+ (instancetype)player
{
    static id               manager = nil;
    static dispatch_once_t  onceToken;

    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });

    return manager;
}

#pragma mark - public
- (void)playTracks:(NSArray *)tracks atIndex:(NSInteger)index
{
    [self pause];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.tracks setArray:tracks];
        _currentTrackIndex = index;
        
        [self _resetStreamer];
    });
}

- (void)playOrPause
{
    if (([_streamer status] == DOUAudioStreamerPaused) || ([_streamer status] == DOUAudioStreamerIdle)) {
        [_streamer play];
    } else {
        [_streamer pause];
    }
}

- (void)playOrPause:(BSTrack *)track
{
    if (!track) {
        return;
    }
    
    if ([self.currentTrack isEqual:track]) {
        [self playOrPause];
        return;
    }
    
    [self playTracks:@[track] atIndex:0];
}

- (void)playTrack:(BSTrack *)track atTime:(float)time
{
    if (!track) {
        return;
    }
    
    if (![self.currentTrack isEqual:track]) {
        [self playTracks:@[track] atIndex:0];
    }
    
    [self setCurrentTime:time];
    [self play];
}

- (void)play
{
    [_streamer play];
}

- (void)pause
{
    [_streamer pause];
}

- (void)stop
{
    [_streamer stop];
}

- (void)next
{
    if (self.tracks.count == 0) {
        return;
    }

    switch (self.cycleType) {
        case BSMusicCycleTypeDefault:
            {
                if (++_currentTrackIndex >= [_tracks count]) {
                    return;
                }

                break;
            }

        case BSMusicCycleTypeSingle:
            {
                break;
            }

        case BSMusicCycleTypeRandom:
            {
                _currentTrackIndex = arc4random() % (self.tracks.count);
                break;
            }

        default:
            break;
    }

    [self _resetStreamer];
}

- (void)previous
{
    if (self.tracks.count == 0) {
        return;
    }

    switch (self.cycleType) {
        case BSMusicCycleTypeDefault:
            {
                if (--_currentTrackIndex <= 0) {
                    _currentTrackIndex = 0;
                }

                break;
            }

        case BSMusicCycleTypeSingle:
            {
                break;
            }

        case BSMusicCycleTypeRandom:
            {
                _currentTrackIndex = arc4random() % (self.tracks.count);
                break;
            }

        default:
            break;
    }

    [self _resetStreamer];
}

- (BSTrack *)currentTrack
{
    if (self.tracks.count > _currentTrackIndex) {
        return self.tracks[_currentTrackIndex];
    }

    return nil;
}

+ (NSUInteger)durationForUrl:(NSURL *)url
{
    BSTrack *track = [[BSTrack alloc] init];
    track.audioFileURL = url;
    DOUAudioFileProvider *provider = [DOUAudioFileProvider fileProviderWithAudioFile:track];
    DOUAudioPlaybackItem *item = [DOUAudioPlaybackItem playbackItemWithFileProvider:provider];
    
    [item open];
    NSUInteger duration = item.estimatedDuration / 1000;
    [item close];
    
    return duration;
}

#pragma mark - getter
- (DOUAudioStreamerStatus)status
{
    return _streamer.status;
}

- (NSTimeInterval)currentTime
{
    return _streamer.currentTime;
}

- (void)setCurrentTime:(NSTimeInterval)currentTime
{
    [_streamer setCurrentTime:currentTime];
}

#pragma mark - private
- (void)_cancelStreamer
{
    if (_streamer != nil) {
        [_streamer pause];
        [_streamer removeObserver:self forKeyPath:@"status"];
        [_streamer removeObserver:self forKeyPath:@"bufferingRatio"];
        _streamer = nil;
    }
}

- (void)_resetStreamer
{
    [self _cancelStreamer];

    if ([_tracks count] == 0) {
        return;
    }

    if (_tracks.count <= _currentTrackIndex) {
        _currentTrackIndex = 0;
    }

    BSTrack *track = [_tracks objectAtIndex:_currentTrackIndex];

    _streamer = [DOUAudioStreamer streamerWithAudioFile:track];
    [_streamer addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:kStatusKVOKey];
    [_streamer addObserver:self forKeyPath:@"bufferingRatio" options:NSKeyValueObservingOptionNew context:kBufferingRatioKVOKey];
    
    [_streamer play];

    [self _setupHintForStreamer];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker error:nil];
}

- (void)_setupHintForStreamer
{
    NSUInteger nextIndex = _currentTrackIndex + 1;

    if (nextIndex >= [_tracks count]) {
        nextIndex = 0;
    }

    [DOUAudioStreamer setHintWithAudioFile:[_tracks objectAtIndex:nextIndex]];
}

- (void)statusChanged
{
    switch ([_streamer status]) {
        case DOUAudioStreamerPlaying:
            break;

        case DOUAudioStreamerPaused:
            break;

        case DOUAudioStreamerIdle:
            break;

        case DOUAudioStreamerFinished:
            [self next];
            break;

        case DOUAudioStreamerBuffering:
            break;

        case DOUAudioStreamerError:
            break;
    }
}

//-(void)routeChange:(NSNotification *)notification
//{
//    NSDictionary *dic=notification.userInfo;
//    AVAudioSessionRouteChangeReason changeReason= [dic[AVAudioSessionRouteChangeReasonKey] intValue];
//    //等于AVAudioSessionRouteChangeReasonOldDeviceUnavailable表示旧输出不可用
//    if (changeReason==AVAudioSessionRouteChangeReasonOldDeviceUnavailable) {
//        AVAudioSessionRouteDescription *routeDescription=dic[AVAudioSessionRouteChangePreviousRouteKey];
//        AVAudioSessionPortDescription *portDescription= [routeDescription.outputs firstObject];
//        //原设备为耳机则暂停
//        if ([portDescription.portType isEqualToString:@"Headphones"]) {
////            if (_streamer) {
////                [self playButtonAction:_playButton];
////            }
//            
//        }
//    }
//}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if (context == kStatusKVOKey) {
        BSTrack                 *track = [self currentTrack];
        DOUAudioStreamerStatus  status = _streamer.status;

        if (!track) {
            return;
        }

        [self statusChanged];

        NSDictionary *userInfo = @{BS_MUSIC_PLAYER_NOTIFICATION_KEY_TRACK : track,
                                   BS_MUSIC_PLAYER_NOTIFICATION_KEY_STATUS : @(status)};
        [[NSNotificationCenter  defaultCenter] postNotificationName:BS_MUSIC_PLAYER_STATUS_CHANGED_NOTIFICATION object:nil userInfo:userInfo];
    } else if (context == kBufferingRatioKVOKey) {
//        NSLog(@"##%@", [NSString stringWithFormat:@"Received %.2f/%.2f MB (%.2f %%), Speed %.2f MB/s", (double)[_streamer receivedLength] / 1024 / 1024, (double)[_streamer expectedLength] / 1024 / 1024, [_streamer bufferingRatio] * 100.0, (double)[_streamer downloadSpeed] / 1024 / 1024]);
    }
}

@end
