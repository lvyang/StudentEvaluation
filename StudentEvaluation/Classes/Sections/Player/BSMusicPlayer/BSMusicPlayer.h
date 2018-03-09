//
//  BSMusicPlayer.h
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/10/9.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DOUAudioStreamer.h>
#import "BSTrack.h"

// notification
static NSString *BS_MUSIC_PLAYER_STATUS_CHANGED_NOTIFICATION = @"music_player_status_changed";

static NSString *BS_MUSIC_PLAYER_NOTIFICATION_KEY_STATUS = @"kPlayerStatus";
static NSString *BS_MUSIC_PLAYER_NOTIFICATION_KEY_TRACK = @"kPlayerTrack";

typedef NS_ENUM (NSInteger, BSMusicCycleType) {
    BSMusicCycleTypeDefault,    // 顺序播放
    BSMusicCycleTypeSingle,     // 单曲循环
    BSMusicCycleTypeRandom      // 随机播放
};

@interface BSMusicPlayer : NSObject

@property (nonatomic, assign, readonly) DOUAudioStreamerStatus  status;
@property (nonatomic, assign) BSMusicCycleType                  cycleType;

+ (instancetype)player;

+ (NSUInteger)durationForUrl:(NSURL *)url;

- (void)playTracks:(NSArray *)tracks atIndex:(NSInteger)index;
- (void)playTrack:(BSTrack *)track atTime:(float)time;
- (void)playOrPause;
- (void)playOrPause:(BSTrack *)track;

- (void)play;
- (void)pause;
- (void)stop;

- (void)next;
- (void)previous;

- (BSTrack *)currentTrack;

- (NSTimeInterval)currentTime;
- (void)setCurrentTime:(NSTimeInterval)currentTime;

@end
