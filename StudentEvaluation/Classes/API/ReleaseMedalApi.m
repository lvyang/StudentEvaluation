//
//  ReleaseMedalApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/12.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ReleaseMedalApi.h"
#import "BSSettings.h"
#import "VoiceModel.h"
#import "BSAttachmentModel.h"
#import <AFURLRequestSerialization.h>

@implementation ReleaseMedalApi
{
    NSString *_teacherId;
    NSString *_medalId;
    NSString  *_studentIds;
    NSString *_classId;
    NSNumber *_score;
    NSString *_desc;
    
    NSArray *_voices;
    NSArray *_attachment;
}

- (id)initWithTeacherId:(NSString *)teacherId medalId:(NSString *)medalId studentIds:(NSString *)studentIds classId:(NSString *)classId score:(NSNumber *)score desc:(NSString *)desc voices:(NSArray *)voices photos:(NSArray *)attachment
{
    self = [super init];
    
    if (self) {
        _teacherId = teacherId;
        _medalId = medalId;
        _studentIds = studentIds;
        _classId = classId;
        _score = score;
        _desc = desc;
        
        _voices = voices;
        _attachment = attachment;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/medal/awardMedalToStudent";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"teacherId": _teacherId ? : @"",
             @"medalId": _medalId ? : @"",
             @"studentIds": _studentIds ? : @"",
             @"classId": _classId ? : @"",
             @"score": _score ? : @0,
             @"description": _desc ? : @"",
             @"source": @"2"};
}

- (AFConstructingBlock)constructingBodyBlock
{
    return ^(id <AFMultipartFormData> formData) {
        
        for (VoiceModel *model in _voices) {
            NSString *name = [NSString stringWithFormat:@"%lu.mp3",(unsigned long)model.path.hash];
            NSString *type = @"audio/mp3";
            NSData *fileData = [NSData dataWithContentsOfFile:model.path];
            [formData appendPartWithFileData:fileData name:name fileName:name mimeType:type];
        }

        for (BSAttachmentModel *model in _attachment) {
            if (model.isVideo) {
                NSString *name = [NSString stringWithFormat:@"%lu.mp4",(unsigned long)model.videoPath.hash];
                NSString *type = @"audio/mp4";
                NSData *fileData = [NSData dataWithContentsOfFile:model.videoPath];
                [formData appendPartWithFileData:fileData name:name fileName:name mimeType:type];
            } else {
                NSString *name = [NSString stringWithFormat:@"%lu.jpeg",(unsigned long)model.asset.localIdentifier];
                NSString *type = @"image/jpeg";
                NSData *fileData = UIImageJPEGRepresentation(model.image, 0.75);
                [formData appendPartWithFileData:fileData name:name fileName:name mimeType:type];
            }
        }
    };
}

@end
