//
//  BSSubjectModel.m
//  BSModel
//
//  Created by Yang.Lv on 2017/3/16.
//  Copyright © 2017年 lvyang. All rights reserved.
//

#import "BSSubjectModel.h"

@implementation BSSubjectModel

+ (NSDictionary *)modelCustomPropertyMapper
{
    return @{
             @"code":@[@"code",@"subject_code"],
             @"name":@[@"name",@"subject_name"]
             };
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super init]) {
        self.code = [aDecoder decodeObjectForKey:@"code"];
        self.name = [aDecoder decodeObjectForKey:@"name"];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.code forKey:@"code"];
    [coder encodeObject:self.name forKey:@"name"];
}

@end
