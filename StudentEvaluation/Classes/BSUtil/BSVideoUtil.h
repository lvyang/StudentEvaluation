//
//  BSVideoUtil.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/8.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSVideoUtil : NSObject

/**
 *  @description 获取本地视频缩略图
 */
+ (UIImage *)screenShotImageFromVideoPath:(NSString *)filePath;

/**
 *  @description 获取视频时长
 */
+ (NSTimeInterval)durationFromVideoPath:(NSString *)filePath;

@end
