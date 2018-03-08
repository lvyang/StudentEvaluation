//
//  BSVideoUtil.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/8.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSVideoUtil.h"
#import <AVFoundation/AVFoundation.h>

@implementation BSVideoUtil

+ (UIImage *)screenShotImageFromVideoPath:(NSString *)filePath
{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:filePath] options:nil];
    AVAssetImageGenerator *assetGen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetGen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 600);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef image = [assetGen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    UIImage *videoImage = [[UIImage alloc] initWithCGImage:image];
    CGImageRelease(image);
    return videoImage;

//    NSURL                   *fileURL = [NSURL fileURLWithPath:filePath];
//    AVURLAsset              *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
//    AVAssetImageGenerator   *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//
//    generator.appliesPreferredTrackTransform = YES;
//
//    CMTime      time = CMTimeMakeWithSeconds(0.0, 600);
//    NSError     *error = nil;
//    CGImageRef  image = [generator copyCGImageAtTime:time actualTime:NULL error:&error];
//    UIImage     *screenShort = [[UIImage alloc] initWithCGImage:image];
//    CGImageRelease(image);
//
//    return screenShort;
}

+ (NSTimeInterval)durationFromVideoPath:(NSString *)filePath
{
    NSURL           *url = [NSURL URLWithString:filePath];
    NSDictionary    *options = @{AVURLAssetPreferPreciseDurationAndTimingKey : @(NO)};
    AVURLAsset      *asset = [AVURLAsset URLAssetWithURL:url options:options];
    
    return asset.duration.value / asset.duration.timescale;
}

@end
