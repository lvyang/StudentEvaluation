//
//  BSLoginManager.h
//  Pods
//
//  Created by Yang.Lv on 2017/3/18.
//
//


#import <Foundation/Foundation.h>
#import "BSUserModel.h"

// 登录成功通知
#define BS_LOGIN_SUCCESS @"BSLoginSuccessNotification"
// 登出成功通知
#define BS_LOGOUT_SUCCESS @"BSLogoutSuccessNotification"
// 去注册通知
#define BS_GO_FOR_REGIST @"BSGoForRegistNotification"

static NSInteger USER_NOT_CERTIFICATE_ERROR_CODE = 415;


@interface BSLoginManager : NSObject

@property (nonatomic, strong) BSUserModel *userModel;

// 已登录token
@property (nonatomic, strong) NSString *accessToken;

/**
 *  @description: 单例方法
 */
+ (instancetype)shareManager;

/**
 *  @description: 判断用户是否已经登录
 */
- (BOOL)isLogin;

/**
 *  @description: 登录方法
 *
 *  @param userName  用户名
 *  @param password  密码+
 *  @param completed  回调block
 */
- (void)loginWithUserName:(NSString *)userName password:(NSString *)password completed:(void(^)(NSError *error, NSDictionary *response))completed;

/**
 *  @description 删除当前用户信息
 */
- (void)removerCurrentUserInfo;

/**
 *  @description 更新当前用户信息
 */
- (void)updateCurrentUser:(BSUserModel *)userModel;

@end
