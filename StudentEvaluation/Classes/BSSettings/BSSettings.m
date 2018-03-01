//
//  BSSettings.m
//  BSSettings
//
//  Created by Yang.Lv on 2017/3/28.
//  Copyright © 2017年 lvyang. All rights reserved.
//

#import "BSSettings.h"

@interface BSSettings ()

@end

@implementation BSSettings

+ (NSDictionary *)settings
{
    static NSDictionary *settings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"];
        
        if (!path) {
            @throw [NSException exceptionWithName:@"无法找到 Setting.plist 文件" reason:@"BSSetting组件需要从Setting.plist中读取配置信息" userInfo:nil];
        }
        settings = [NSDictionary dictionaryWithContentsOfFile:path];
    });
    
    return settings;
}

+ (BOOL)isProduct
{
    return [[[[self settings] objectForKey:@"environment"] objectForKey:@"isProduct"] boolValue];
}

+ (NSDictionary *)environment
{
    return [[self settings] objectForKey:@"environment"];
}

#pragma mark - app information
+ (NSString *)appId
{
    NSDictionary *dic = [self isProduct] ? [[self environment] objectForKey:@"production"]: [[self environment] objectForKey:@"test"];
    return [dic objectForKey:@"app_id"];
}

+ (NSString *)appKey
{
    NSDictionary *dic = [self isProduct] ? [[self environment] objectForKey:@"production"]: [[self environment] objectForKey:@"test"];
    return [dic objectForKey:@"app_key"];
}

#pragma mark - share information
+ (NSDictionary *)shareDictionary
{
    return [[self settings] objectForKey:@"share"];
}

#pragma mark - base url
+ (NSString *)baseUrl
{
    NSDictionary *dic = [self isProduct] ? [[self environment] objectForKey:@"production"]: [[self environment] objectForKey:@"test"];
    return [dic objectForKey:@"base_url"];
}

@end
