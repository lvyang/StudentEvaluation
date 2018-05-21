//
//  UIImage+ImageFromColor.h
//  dodoedu
//
//  Created by Yang.Lv on 16/7/19.
//  Copyright © 2016年 bosu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ImageAddition)

/**
 *  @description: 根据屏幕scale从指定bundle中加载图片。
 *
 *  @param bundle  bundle对象
 *  @param imageName  图片名称
 *
 *  @return: 最适合当前屏幕的图片
 */
+ (UIImage *)imagesFromBundle:(NSBundle *)bundle imageName:(NSString *)imageName;

/**
 *  @description: 将颜色转换为图片，图片大小为1x1
 */
+ (UIImage *)imageFromColor:(UIColor *)color;

/**
 *  @description 对图片进行模糊处理。NOTE:此操作比较耗时
 *
 *  @param blur  模糊等级
 *
 *  @return: 模糊处理后的图片
 */
- (UIImage *)blurImageWithBlurLevel:(CGFloat)blur;

/**
 *  @description: 将图片旋转到某个方向
 */
- (UIImage *)rotateToOrientation:(UIImageOrientation)orientation;

@end
