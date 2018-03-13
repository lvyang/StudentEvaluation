//
//  BSAttachmentModel.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/6.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface BSAttachmentModel : NSObject

@property (nonatomic, strong) PHAsset   *asset; // 仅针对相册中图片
@property (nonatomic, strong) UIImage   *image; // 图片对象或者视频缩略图

@property (nonatomic, assign) BOOL      isVideo;
@property (nonatomic, strong) NSString  *videoPath;     // 视频路径
@property (nonatomic, strong) NSNumber  *videoDuration; // 视频时长

@end
