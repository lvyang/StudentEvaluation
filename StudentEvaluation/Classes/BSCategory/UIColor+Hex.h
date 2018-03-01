//
//  UIColor+Hex.h
//  PublicationRead
//
//  Created by admin zheng on 15/9/14.
//  Copyright (c) 2015年 bosu. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UIColor (Hex)

/**
 *  @description: 将形如“666666”或“0x666666”的字符串转换为UIColor对象
 */
+ (UIColor *)colorWithHexString:(NSString *)color;

@end
