//
//  NoticeModel.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/16.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{@"content":@"conent",
             @"createDate":@"createTime",
             @"day":@"day",
             @"dayTime":@"dayTime",
             @"identifier":@"id",
             @"medalScoreId":@"medal_score_id",
             @"readStatus":@"red_status",
             @"status":@"status",
             @"studentId":@"student_id",
             @"studentName":@"student_name",
             @"title":@"title",
             @"wheherEvaluate":@"whetherEvaluate"};
}

- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic
{
    if ([[dic objectForKey:@"createTime"] isKindOfClass:[NSNumber class]]) {
        self.createDate = [NSDate dateWithTimeIntervalSince1970:[[dic objectForKey:@"createTime"] doubleValue]];
    }
    
    return YES;
}

@end
