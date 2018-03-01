//
//  NetworkManager.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/1.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "NetworkManager.h"
#import "GetVerifyCodeApi.h"
#import "BSParseUtil.h"
#import "ChangePasswordApi.h"

@implementation NetworkManager

+ (void)getVerficationCode:(NSString *)phone userId:(NSString *)userId completed:(void(^)(NSError *error ,NSString *code))completed
{
    GetVerifyCodeApi *api = [[GetVerifyCodeApi alloc] initPhoneNumber:phone userId:nil];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest * _Nonnull request) {
        NSDictionary *json = request.responseJSONObject;
        NSInteger   errorCode = [[json objectForKey:@"code"] integerValue];

        if (errorCode != 200) {
            NSString *errorMessage = [json objectForKey:@"msg"] ? : @"操作失败";

            NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
            completed(error, nil);
            return ;
        }
        
        NSString *code = [[json objectForKey:@"content"] objectForKey:@"code"];
        completed(nil, code);
    } failure:^(YTKBaseRequest * _Nonnull request) {
        completed(request.error, nil);
    }];

}

+ (void)resetPassword:(NSString *)password verifyCode:(NSString *)verifyCode phone:(NSString *)phone completed:(void(^)(NSError *error))completed
{
    ChangePasswordApi *api = [[ChangePasswordApi alloc] initPhoneNumber:phone verifyCode:verifyCode password:password];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest * _Nonnull request) {
        NSDictionary *json = request.responseJSONObject;
        NSInteger   errorCode = [[json objectForKey:@"code"] integerValue];
        
        if (errorCode != 200) {
            NSString *errorMessage = [json objectForKey:@"msg"] ? : @"操作失败";
            
            NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
            completed(error);
            return ;
        }
        
        completed(nil);

    } failure:^(YTKBaseRequest * _Nonnull request) {
        completed(request.error);
    }];
}

@end
