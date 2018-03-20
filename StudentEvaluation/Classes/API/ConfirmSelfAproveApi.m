//
//  ConfirmSelfAproveApi.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ConfirmSelfAproveApi.h"
#import "BSSettings.h"
#import "VoiceModel.h"
#import "BSAttachmentModel.h"
#import <AFURLRequestSerialization.h>

@implementation ConfirmSelfAproveApi
{
    NSString *_teacherId;
    NSString *_comment;
    NSString *_studentId;
    NSNumber *_score;
    NSString *_studentSelfId;
    
    NSArray *_voices;
    NSArray *_attachment;
}

- (id)initWithTeacherId:(NSString *)teacherId comment:(NSString *)comment studentId:(NSString *)studentId score:(NSNumber *)score studentSelfId:(NSString *)studentSelfId voices:(NSArray *)voices photos:(NSArray *)attachment
{
    self = [super init];
    
    if (self) {
        _teacherId = teacherId;
        _comment = comment;
        _studentId = studentId;
        _score = score;
        _studentSelfId = studentSelfId;
        
        _voices = voices;
        _attachment = attachment;
    }
    
    return self;
}

- (NSString *)requestUrl
{
    return @"appapi/selfProve/evaluateStudentSelfByTeacher";
}

- (id)requestArgument
{
    return @{@"appid": ([BSSettings appId] ? : @""),
             @"appkey": ([BSSettings appKey] ? : @""),
             @"comment": _comment ? : @"",
             @"teacherId": _teacherId ? : @"",
             @"studentSelfId": _studentSelfId ? : @"",
             @"score": _score ? : @0,
             @"studentId": _studentId ? : @""};
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
                NSString *type = @"video/mp4";
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
