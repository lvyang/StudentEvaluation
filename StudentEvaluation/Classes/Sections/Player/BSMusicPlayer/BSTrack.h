//
//  BSTrack.h
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/10/10.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <DOUAudioFile.h>

@interface BSTrack : NSObject<DOUAudioFile>

@property (nonatomic, strong) NSString *identifier;

@property (nonatomic, strong) NSString *iconUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSURL *audioFileURL;

@end
