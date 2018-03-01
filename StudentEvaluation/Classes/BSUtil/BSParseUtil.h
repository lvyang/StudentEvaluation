//
//  BSParseUtil.h
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/11/17.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSParseUtil : NSObject

+ (id)parseObjectFromJson:(NSDictionary *)json modelClass:(Class)modelClass error:(NSError **)error;
+ (NSError *)parseStatusFromJson:(NSDictionary *)json errorMessage:(NSString *)message;

@end
