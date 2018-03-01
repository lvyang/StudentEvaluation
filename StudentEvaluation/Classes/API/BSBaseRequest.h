//
//  BSBaseRequest.h
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/9/23.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>

// 网络请求accessToken过期通知
static NSString *DODOEDU_ACCESS_TOKEN_EXPIRE_NOTIFICATION = @"dodoedu_access_token_expire_notification";
// 网络请求accessToken错误(当前账号已在其他设备登录)通知
static NSString *DODOEDU_ACCESS_TOKEN_ERROR_NOTIFICATION = @"dodoedu_access_token_error_notification";

// 通知的key
static NSString *DODOEDU_ACCESS_TOKEN_NOTIFICATION_KEY_ERROR = @"dodoedu_access_token_notification_error";
static NSString *DODOEDU_ACCESS_TOKEN_NOTIFICATION_KEY_REQUEST = @"dodoedu_access_token_notification_request";
static NSString *DODOEDU_ACCESS_TOKEN_NOTIFICATION_KEY_REQUEST_SUCCESS_BLOCK = @"dodoedu_access_token_notification_request_success_block";
static NSString *DODOEDU_ACCESS_TOKEN_NOTIFICATION_KEY_REQUEST_FAILURE_BLOCK = @"dodoedu_access_token_notification_request_failure_block";

@interface BSBaseRequest : YTKRequest

@end
