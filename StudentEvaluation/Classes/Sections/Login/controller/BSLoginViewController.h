//
//  BSLoginViewController.h
//  BSResourceModule
//
//  Created by admin zheng on 2017/3/16.
//  Copyright © 2017年 lvyang. All rights reserved.
//
/**
 MGJRouter注册链接：BS://Login
 需要传参:无
 */


#import <UIKit/UIKit.h>
#import "BSViewController.h"


@interface BSLoginViewController : BSViewController

/** 客服电话，默认值为tel://400-886-6561 */
@property (nonatomic,copy)  NSString * servicePhoneNum;

/** 用户头像 */
@property (nonatomic, weak) IBOutlet UIImageView * icon;

/** 用户名TextField */
@property (nonatomic, weak) IBOutlet UITextField * userNameField;

/** 用户密码TextField */
@property (nonatomic, weak) IBOutlet UITextField * userPWField;

/** 用户自设定接口参数 */
@property (nonatomic, strong)  NSDictionary * userLoginParamsDict;

/** 用户自设定接口baseURL */
@property (nonatomic,copy)  NSString * loginBaseURL;

/** 用户自基本信息 */
@property (nonatomic,strong)  NSDictionary * userInfo;

@end
