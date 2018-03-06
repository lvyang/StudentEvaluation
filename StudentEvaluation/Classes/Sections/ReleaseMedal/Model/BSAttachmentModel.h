//
//  BSAttachmentModel.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/6.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSAttachmentModel : NSObject

@property (nonatomic, strong) NSString *thumnailUrl;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, assign) BOOL isVideo;

@property (nonatomic, strong) NSNumber *videoLength;

@end
