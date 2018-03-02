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
#import "FequentlyUsedMedalApi.h"
#import "ClassListApi.h"
#import "BSClassModel.h"
#import "BSMedalModel.h"
#import "MedalLibraryApi.h"

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

+ (void)fequentlyUsedMedalForTeacher:(NSString *)teacherId class:(NSString *)classId medalType:(NSNumber *)medalType completed:(void(^)(NSError *error,NSArray *result))completed
{
    FequentlyUsedMedalApi *api = [[FequentlyUsedMedalApi alloc] initWithTeacherId:teacherId classId:classId medalType:medalType];
    [api startWithCompletionBlockWithSuccess:^(YTKBaseRequest * _Nonnull request) {
        NSError *error = nil;
        NSArray * array = [BSParseUtil parseObjectFromJson:request.responseJSONObject modelClass:[BSMedalModel class] error:&error];
        completed(error, array);
    } failure:^(YTKBaseRequest * _Nonnull request) {
        completed(request.error, nil);
    }];
}

+ (void)classListForTeacherId:(NSString *)teacherId completed:(void(^)(NSError *error,NSArray *result))completed
{
    ClassListApi *api = [[ClassListApi alloc] initWithTeacherId:teacherId];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSError *error = nil;
        NSArray * array = [BSParseUtil parseObjectFromJson:request.responseJSONObject modelClass:[BSClassModel class] error:&error];
        completed(error, array);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(request.error, nil);
    }];
}

+ (void)loadMedalLibraryForTeacher:(NSString *)teacherId class:(NSString *)classId medalType:(NSNumber *)medalType completed:(void(^)(NSError *error,NSArray *result))completed
{
    MedalLibraryApi *api = [[MedalLibraryApi alloc] initWithTeacherId:teacherId classId:classId medalType:medalType];
    [api startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        NSInteger   errorCode = [[request.responseJSONObject objectForKey:@"code"] integerValue];
        
        if (errorCode != 200) {
            NSString *errorMessage = [request.responseJSONObject objectForKey:@"msg"];
            errorMessage = errorMessage ? : @"操作失败";
            
            NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
            completed(error, nil);
            return ;
        }

        NSArray *content = [request.responseJSONObject objectForKey:@"content"];
        NSMutableArray *object = [NSMutableArray array];
        for (NSDictionary *dic in content) {
            NSArray *array = [dic objectForKey:@"data"];
            NSNumber *fieldId = [dic objectForKey:@"vedioo_id"];
            NSString *fieldName = [dic objectForKey:@"veidoo_name"];
            NSMutableArray *tempArray = [NSMutableArray array];
            for (NSDictionary *json in array) {
                BSMedalModel *medal = [BSMedalModel yy_modelWithJSON:json];
                medal.medalFieldId = fieldId;
                medal.medalFieldName = fieldName;
                [tempArray addObject:medal];
            }
            
            [object addObject:tempArray];
        }

        completed(nil, object);
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        completed(request.error, nil);
    }];
}

@end
