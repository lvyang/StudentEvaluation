//
//  BSSettings.h
//  BSSettings
//
//  Created by Yang.Lv on 2017/3/28.
//  Copyright © 2017年 lvyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSSettings : NSObject

/**
 *  @description: 读取 NSBundle 中的Setting.plist信息
 */
+ (NSDictionary *)settings;

/**
 *  @description: 读取app的 appID,appKey,appSecret三个信息
 */
+ (NSString *)appId;
+ (NSString *)appKey;

/**
 *  @description: 读取分享相关的配置信息
 */
+ (NSDictionary *)shareDictionary;

/**
 *  @description: api domain。 根据Setting.plist 中 isProduct字段判断当前环境是生产环境还是测试环境，读取对应环境的url路径
 */
+ (NSString *)baseUrl;

@end
