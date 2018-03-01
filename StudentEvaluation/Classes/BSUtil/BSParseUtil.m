//
//  BSParseUtil.m
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/11/17.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "BSParseUtil.h"
#import <YYModel.h>

@implementation BSParseUtil

+ (id)parseObjectFromJson:(NSDictionary *)json modelClass:(Class)modelClass error:(NSError **)error
{
    // ret: 0为正确返回，非0为错误
    NSInteger ret = [[json objectForKey:@"ret"] integerValue];
    
    if (ret) {
        NSInteger   errorCode = [[json objectForKey:@"errcode"] integerValue];
        NSString    *message = [json objectForKey:@"msg"] ? : @"加载失败";
        
        if (errorCode == 103) {
            message = @"当前账号已在其他设备登录";
        }
        
        if (error) {
            *error = [NSError errorWithDomain:@"com.dodoedu" code:errorCode userInfo:@{NSLocalizedDescriptionKey : message}];
        }
        
        return nil;
    }
    
    id data = [json objectForKey:@"data"];
    
    if ([data isKindOfClass:[NSArray class]]) {
        NSMutableArray *result = [NSMutableArray array];
        
        for (NSDictionary *dic in data) {
            id model = [modelClass yy_modelWithJSON:dic];
            [result addObject:model];
        }
        
        return result;
    } else if ([data isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dic = data;
        
        if (dic.count == 0) {
            return nil;
        }
        
        id model = [modelClass yy_modelWithJSON:data];
        return model;
    }
    
    return nil;
}

// data中只含有status的回调处理
+ (NSError *)parseStatusFromJson:(NSDictionary *)json errorMessage:(NSString *)message
{
    NSInteger   errorCode = [[json objectForKey:@"code"] integerValue];
    
    if (errorCode != 200) {
        NSString *errorMessage = [json objectForKey:@"msg"] ? : [self errorMessageFromCode:errorCode];
        errorMessage = message ? : (errorMessage ? : @"操作失败");
        
        NSError *error = [NSError errorWithDomain:@"com.dodoedu" code:errorCode userInfo:@{NSLocalizedDescriptionKey : errorMessage}];
        return error;
    }
    
    NSError *error = nil;
    BOOL    status = [[[json objectForKey:@"data"] objectForKey:@"status"] boolValue];
    
    if (!status) {
        NSString *errorMessage = message ? : ([[json objectForKey:@"data"] objectForKey:@"message"] ? : @"操作失败");
        error = [NSError errorWithDomain:@"com.dodoedu" code:888 userInfo:@{NSLocalizedDescriptionKey:errorMessage}];
    }
    
    return error;
}

+ (NSString *)errorMessageFromCode:(NSInteger)code
{
    NSString *message = nil;
    
    switch (code) {
            case 1:
            message = @"无此用户信息";
            break;
            
            case 2:
            message = @"用户名错误";
            break;
            
            case 3:
            message = @"密码错误";
            break;

            case 4:
            message = @"重复密码错误";
            break;

            case 5:
            message = @"appid,appkey验证失败";
            break;

            case 7:
            message = @"无此用户信息";
            break;

            case 8:
            message = @"token失效，需要重新登录";
            break;

            case 9:
            message = @"缺少必要参数";
            break;

            case 300:
            message = @"手机号码格式有误";
            break;

            case 301:
            message = @"短信发送失败";
            break;

            case 302:
            message = @"验证码错误";
            break;

            case 303:
            message = @"密码格式有误,正确的密码为6-12位包含字母和小数";
            break;

            case 304:
            message = @"新旧密码重复";
            break;

            case 305:
            message = @"该手机号码已经绑定过该用户";
            break;

            case 306:
            message = @"验证码已失效，请重新获取！";
            break;

            case 307:
            message = @"该手机号当日操作次数达到上线！";
            break;

            case 400:
            message = @"所选勋章不存在或已失效!";
            break;

            case 401:
            message = @"该教师未拥有撤销该勋章颁发记录的权限!";
            break;

            case 402:
            message = @"该勋章颁发记录不存在或已失效!";
            break;

            case 403:
            message = @"勋章颁发已超过五分钟,无法撤回!";
            break;

            case 404:
            message = @"该自证材料不存在或已失效!";
            break;

            case 405:
            message = @"该自证材料所属的考察要点下没有勋章,无法进行鼓励操作!";
            break;

        default:
            break;
    }
    
    return message;
}

@end
