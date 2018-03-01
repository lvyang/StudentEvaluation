//
//  UIView+Additional.m
//  dodoedu
//
//  Created by Yang.Lv on 16/8/2.
//  Copyright © 2016年 bosu. All rights reserved.
//

#import "UIView+Additional.h"
#import <objc/runtime.h>

@implementation UIView (Additional)

+ (void)load
{
    Method didSetBounds = class_getInstanceMethod([UIView class], @selector(didSetBounds:));
    Method setBounds = class_getInstanceMethod([UIView class], @selector(setBounds:));
    method_exchangeImplementations(didSetBounds, setBounds);
}

// 监测UIView的bounds的变化，进而修改添加的border的frame
- (void)didSetBounds:(CGRect)bounds
{
    [self didSetBounds:bounds];
    for (CALayer *layer in self.layer.sublayers) {
        UIEdgeInsets inset = [[layer.style objectForKey:@"inset"] UIEdgeInsetsValue];
        if ([layer.name isEqualToString:@"top"]) {
            layer.frame = CGRectMake(inset.left, inset.top, self.frame.size.width - inset.left - inset.right, layer.frame.size.height);
            continue;
        } else if ([layer.name isEqualToString:@"right"]) {
            layer.frame = CGRectMake(self.frame.size.width - layer.frame.size.width - inset.right, inset.top, layer.frame.size.width, self.frame.size.height - inset.top - inset.bottom);
            continue;
        } else if ([layer.name isEqualToString:@"bottom"]) {
            layer.frame = CGRectMake(inset.left, self.frame.size.height - layer.frame.size.height - inset.bottom, self.frame.size.width - inset.left - inset.right, layer.frame.size.height);
            continue;
        } else if ([layer.name isEqualToString:@"left"]) {
            layer.frame = CGRectMake(inset.left, inset.top, layer.frame.size.width, self.frame.size.height - inset.top - inset.bottom);
            continue;
        }
    }
}

- (void)addDashLineWithLineWidth:(CGFloat)width lineColor:(UIColor *)lineColor cornerRadius:(CGFloat)radius
{
    CAShapeLayer *border = [CAShapeLayer layer];
    border.strokeColor = lineColor.CGColor;
    border.fillColor = nil;
    border.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:radius].CGPath;
    border.frame = self.bounds;
    border.lineWidth = width;
    border.lineCap = @"square";
    border.lineDashPattern = @[@4, @2];
    [self.layer addSublayer:border];
}


- (void)maskWithSide:(NSInteger)sides cornerRadius:(CGFloat)radius;
{
    CGFloat lineWidth    = 5.0;
    UIBezierPath *path   = [self _roundedPolygonPathWithRect:self.bounds
                                                   lineWidth:lineWidth
                                                       sides:sides
                                                cornerRadius:radius];
    
    CAShapeLayer *mask   = [CAShapeLayer layer];
    mask.path            = path.CGPath;
    mask.lineWidth       = lineWidth;
    mask.strokeColor     = [UIColor clearColor].CGColor;
    mask.fillColor       = [UIColor whiteColor].CGColor;
    self.layer.mask = mask;
}

- (void)roundingCorners:(UIRectCorner)corner radius:(CGFloat)radius
{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds
                                                   byRoundingCorners:corner
                                                         cornerRadii:CGSizeMake(radius, radius)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
}

- (void)addBorderOnDirections:(BorderDirections)directions width:(CGFloat)borderWidth color:(UIColor *)borderColor
{
    [self addBorderOnDirections:directions width:borderWidth color:borderColor inset:UIEdgeInsetsZero];
}

- (void)addBorderOnDirections:(BorderDirections)directions width:(CGFloat)borderWidth color:(UIColor *)borderColor inset:(UIEdgeInsets)inset
{
    if ((directions & BorderDirectionsTop) == BorderDirectionsTop) {
        CALayer *layer = [CALayer layer];
        [layer setName:@"top"];
        layer.frame = CGRectMake(inset.left, inset.top, self.frame.size.width - inset.left - inset.right, borderWidth);
        layer.backgroundColor = borderColor.CGColor;
        layer.style = @{@"inset" : [NSValue valueWithUIEdgeInsets:inset]};
        [self.layer addSublayer:layer];
    }
    
    if ((directions & BorderDirectionsRight) == BorderDirectionsRight) {
        CALayer *layer = [CALayer layer];
        [layer setName:@"right"];
        layer.frame = CGRectMake(self.frame.size.width - borderWidth - inset.right, inset.top, borderWidth, self.frame.size.height - inset.top - inset.bottom);
        layer.backgroundColor = borderColor.CGColor;
        layer.style = @{@"inset" : [NSValue valueWithUIEdgeInsets:inset]};
        [self.layer addSublayer:layer];
    }
    
    if ((directions & BorderDirectionsBottom) == BorderDirectionsBottom) {
        CALayer *layer = [CALayer layer];
        [layer setName:@"bottom"];
        layer.frame = CGRectMake(inset.left, self.frame.size.height - borderWidth - inset.bottom, self.frame.size.width - inset.left - inset.right, borderWidth);
        layer.backgroundColor = borderColor.CGColor;
        layer.style = @{@"inset" : [NSValue valueWithUIEdgeInsets:inset]};
        [self.layer addSublayer:layer];
    }
    
    if ((directions & BorderDirectionsLeft) == BorderDirectionsLeft) {
        CALayer *layer = [CALayer layer];
        [layer setName:@"left"];
        layer.frame = CGRectMake(inset.left, inset.top, borderWidth, self.frame.size.height - inset.top - inset.bottom);
        layer.backgroundColor = borderColor.CGColor;
        layer.style = @{@"inset" : [NSValue valueWithUIEdgeInsets:inset]};
        [self.layer addSublayer:layer];
    }
}

- (void)removeBorderOnDirections:(BorderDirections)directions
{
    for (CALayer *layer in self.layer.sublayers.copy) {
        if ([layer.name isEqualToString:@"top"] && (directions & BorderDirectionsTop) == BorderDirectionsTop) {
            [layer removeFromSuperlayer];
            continue;
        }
        
        if ([layer.name isEqualToString:@"right"] && (directions & BorderDirectionsRight) == BorderDirectionsRight) {
            [layer removeFromSuperlayer];
            continue;
        }
        
        if ([layer.name isEqualToString:@"bottom"] && (directions & BorderDirectionsBottom) == BorderDirectionsBottom) {
            [layer removeFromSuperlayer];
            continue;
        }
        
        if ([layer.name isEqualToString:@"left"] && (directions & BorderDirectionsLeft) == BorderDirectionsLeft) {
            [layer removeFromSuperlayer];
            continue;
        }
    }
}

#pragma mark - private
- (UIBezierPath *)_roundedPolygonPathWithRect:(CGRect)rect
                                    lineWidth:(CGFloat)lineWidth
                                        sides:(NSInteger)sides
                                 cornerRadius:(CGFloat)cornerRadius
{
    UIBezierPath *path  = [UIBezierPath bezierPath];
    
    CGFloat theta       = 2.0 * M_PI / sides;
    CGFloat width = MIN(rect.size.width, rect.size.height);
    
    CGPoint center = CGPointMake(rect.size.width / 2, rect.size.height / 2);
    CGFloat radius = (width - lineWidth + cornerRadius - (cos(theta) * cornerRadius)) / 2.0;
    CGFloat angle = M_PI / 2;
    CGPoint corner = CGPointMake(center.x + (radius - cornerRadius) * cos(angle), center.y + (radius - cornerRadius) * sin(angle));
    
    [path moveToPoint:(CGPointMake(corner.x + cornerRadius * cos(angle + theta), corner.y + cornerRadius * sin(angle + theta)))];
    for (NSInteger side = 0; side < sides; side++) {
        angle += theta;
        
        CGPoint corner = CGPointMake(center.x + (radius - cornerRadius) * cos(angle), center.y + (radius - cornerRadius) * sin(angle));
        CGPoint tip = CGPointMake(center.x + radius * cos(angle), center.y + radius * sin(angle));
        CGPoint start = CGPointMake(corner.x + cornerRadius * cos(angle - theta), corner.y + cornerRadius * sin(angle - theta));
        CGPoint end = CGPointMake(corner.x + cornerRadius * cos(angle + theta), corner.y + cornerRadius * sin(angle + theta));
        
        [path addLineToPoint:start];
        [path addQuadCurveToPoint:end controlPoint:tip];
    }
    [path closePath];
    
    return path;
}


@end
