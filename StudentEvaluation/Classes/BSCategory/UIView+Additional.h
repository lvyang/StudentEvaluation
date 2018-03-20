//
//  UIView+Additional.h
//  dodoedu
//
//  Created by Yang.Lv on 16/8/2.
//  Copyright © 2016年 bosu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, BorderDirections) {
    BorderDirectionsNone    = 0x0,
    
    BorderDirectionsTop     = 1<< 0,
    BorderDirectionsRight   = 1<< 1,
    BorderDirectionsBottom  = 1<< 2,
    BorderDirectionsLeft    = 1<< 3,
    
    BorderDirectionsAll     = 0xFFFFFFFF
};

@interface UIView (Additional)

/**
 *  @description: 给view添加虚线边框
 *
 *  @param width  边框宽度
 *  @param lineColor  边框颜色
 *  @param radius  圆角半径
 */
- (void)addDashLineWithLineWidth:(CGFloat)width lineColor:(UIColor *)lineColor cornerRadius:(CGFloat)radius;

/**
 *  @description: 生成一个多边形的view
 *
 *  @param sides  view的边数
 *  @param radius  圆角
 */
- (void)maskWithSide:(NSInteger)sides cornerRadius:(CGFloat)radius;


/**
 *  @description: 给一个view添加圆角
 *
 *  @param corner  需要添加圆角的部分可选：左上、左下、右上、右下
 *  @param radius  圆角半径
 */
- (void)roundingCorners:(UIRectCorner)corner radius:(CGFloat)radius;


/**
 *  @description: 给view添加border
 *
 *  @param directions  添加border的边
 *  @param borderWidth  border宽
 *  @param borderColor  border颜色
 */
- (void)addBorderOnDirections:(BorderDirections)directions width:(CGFloat)borderWidth color:(UIColor *)borderColor;

/**
 *  @description: 给view添加border
 *
 *  @param directions  添加border的边
 *  @param borderWidth  border宽
 *  @param borderColor  border颜色
 *  @param inset  border的inset
 */
- (void)addBorderOnDirections:(BorderDirections)directions width:(CGFloat)borderWidth color:(UIColor *)borderColor inset:(UIEdgeInsets)inset;

/**
 *  @description: 删除添加的border
 */
- (void)removeBorderOnDirections:(BorderDirections)directions;

@end
