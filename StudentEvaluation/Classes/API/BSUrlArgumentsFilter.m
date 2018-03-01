//
//  BSUrlArgumentsFilter.m
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/9/23.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "BSUrlArgumentsFilter.h"
#import "AFURLRequestSerialization.h"
#import "BSLoginManager.h"

@implementation BSUrlArgumentsFilter {
    NSDictionary *_arguments;
}

+ (instancetype)filterWithArguments:(NSDictionary *)arguments
{
    return [[self alloc] initWithArguments:arguments];
}

- (id)initWithArguments:(NSDictionary *)arguments
{
    if (self = [super init]) {
        _arguments = arguments;
    }
    
    return self;
}

- (NSString *)filterUrl:(NSString *)originUrl withRequest:(YTKBaseRequest *)request
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters addEntriesFromDictionary:_arguments];
    
    NSSet *blackList = [self filterUlrBlackList];
    if ([blackList containsObject:originUrl]) {
        return [BSUrlArgumentsFilter urlStringWithOriginUrlString:originUrl appendParameters:parameters];
    }
    
    if ([BSLoginManager shareManager].accessToken) {
        [parameters setObject:[BSLoginManager shareManager].accessToken forKey:@"token"];
    }
    
    return [BSUrlArgumentsFilter urlStringWithOriginUrlString:originUrl appendParameters:parameters];
}

+ (NSString *)urlStringWithOriginUrlString:(NSString *)originUrlString appendParameters:(NSDictionary *)parameters
{
    NSString    *filteredUrl = originUrlString;
    NSString    *paraUrlString = [self urlParametersStringFromParameters:parameters];
    
    if (paraUrlString.length > 0) {
        if ([originUrlString rangeOfString:@"?"].location != NSNotFound) {
            filteredUrl = [filteredUrl stringByAppendingString:paraUrlString];
        } else {
            filteredUrl = [filteredUrl stringByAppendingFormat:@"?%@", [paraUrlString substringFromIndex:1]];
        }
    }
    
    return filteredUrl;
}

+ (NSString *)urlParametersStringFromParameters:(NSDictionary *)parameters
{
    NSMutableString *urlParametersString = [[NSMutableString alloc] initWithString:@""];
    
    if (parameters && (parameters.count > 0)) {
        for (NSString *key in parameters) {
            NSString *value = parameters[key];
            value = [NSString stringWithFormat:@"%@", value];
            value = [self urlEncode:value];
            [urlParametersString appendFormat:@"&%@=%@", key, value];
        }
    }
    
    return urlParametersString;
}

+ (NSString *)urlEncode:(NSString *)str
{
    return AFPercentEscapedStringFromString(str);
}

- (NSSet *)filterUlrBlackList
{
    return [NSSet setWithObjects:@"auth/mremoteaccesstoken", nil];
}

@end
