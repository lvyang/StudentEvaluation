//
//  BSBaseRequest.m
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/9/23.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "BSBaseRequest.h"

@implementation BSBaseRequest

/** @override */
- (void)startWithCompletionBlockWithSuccess:(YTKRequestCompletionBlock)success failure:(YTKRequestCompletionBlock)failure
{
    YTKRequestCompletionBlock successBlock = ^(__kindof YTKBaseRequest *request) {
        NSDictionary    *response = request.responseObject;
        NSInteger       errorCode = [[response objectForKey:@"code"] integerValue];
        NSError         *error = nil;
        
        switch (errorCode) {
            case 8:
            {
                error = [NSError errorWithDomain:@"com.dodoedu" code:103 userInfo:@{NSLocalizedDescriptionKey : @"token失效，请重新登录"}];
                NSDictionary *userInfo = @{DODOEDU_ACCESS_TOKEN_NOTIFICATION_KEY_ERROR : error,
                                           DODOEDU_ACCESS_TOKEN_NOTIFICATION_KEY_REQUEST: request};
                [[NSNotificationCenter defaultCenter] postNotificationName:DODOEDU_ACCESS_TOKEN_ERROR_NOTIFICATION object:nil userInfo:userInfo];
                NSLog(@"=====token失效，请重新登录======");
                break;
            }
                
            default:
                break;
        }
        
        if (success) {
            success(request);
        }
    };
    
    [super startWithCompletionBlockWithSuccess:successBlock failure:failure];
    
#if DEBUG
    if (self.currentRequest.URL) {
        NSString *requestUrl = [self _outputTagetURL:self.requestArgument withBaseURL:self.currentRequest.URL.absoluteString];
        NSLog(@"%@", requestUrl);
    }
#endif
}

/** @override */
- (YTKRequestMethod)requestMethod
{
    return YTKRequestMethodPOST;
}

#pragma mark - private
- (NSString *)_outputTagetURL:(NSDictionary *)params withBaseURL:(NSString *)url
{
    if (params.count == 0) {
        return url;
    }
    
    if ([url rangeOfString:@"?"].location == NSNotFound) {
        url = [NSString stringWithFormat:@"%@?",url];
    } else {
        url = [NSString stringWithFormat:@"%@&",url];
    }
    NSMutableString *outputURL = [[NSMutableString alloc] initWithString:url];
    
    for (int i = 0; i < params.allKeys.count; i++) {
        NSString    *key = [params.allKeys objectAtIndex:i];
        NSString    *appendStr = nil;
        
        if (i + 1 < params.count) {
            appendStr = [NSString stringWithFormat:@"%@=%@&", key, [params objectForKey:key]];
        } else {
            appendStr = [NSString stringWithFormat:@"%@=%@", key, [params objectForKey:key]];
        }
        
        [outputURL appendString:appendStr];
    }
    
    return outputURL;
}

@end
