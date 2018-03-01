//
//  UIImage+ImageFromColor.m
//  dodoedu
//
//  Created by Yang.Lv on 16/7/19.
//  Copyright © 2016年 bosu. All rights reserved.
//

#import "UIImage+ImageAddition.h"

@implementation UIImage (ImageAddition)

+ (UIImage *)imagesFromBundle:(NSBundle *)bundle imageName:(NSString *)imageName
{
    if (!bundle || imageName.length == 0) {
        return nil;
    }
    
    NSArray *component = [imageName componentsSeparatedByString:@"."];
    if (component.count < 2) {
        return nil;
    }
    
    NSString *name = component.firstObject;
    NSString *extension = component.lastObject;
    NSInteger scale = [UIScreen mainScreen].scale;
    
    // 如果用户输入@"image.png"，则根据屏幕先搜寻@"image@*x.png"的图片，搜不到的话就加载 "image.png"
    if ([name rangeOfString:@"@"].location == NSNotFound) {
        NSString *modifiedName = [NSString stringWithFormat:@"%@@%ldx",name,(long)scale];
        UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:modifiedName ofType:extension]];
        
        if (!image) {
            image = [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:extension]];
        }
        
        return image;
    }
    
    // 如果图片名称包含@"@*x"字样，则去掉，去寻找适合屏幕的图片，寻找不到的话再使用用户输入的图片名称
    NSString *modifiedName = [name componentsSeparatedByString:@"@"].firstObject;
    modifiedName = [NSString stringWithFormat:@"%@@%ldx",name,(long)scale];
    UIImage *image = [UIImage imageWithContentsOfFile:[bundle pathForResource:modifiedName ofType:extension]];
    
    if (!image) {
        image = [UIImage imageWithContentsOfFile:[bundle pathForResource:name ofType:extension]];
    }
    
    return image;
}

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIImage *)blurImageWithBlurLevel:(CGFloat)blur
{
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *imageToBlur = [[CIImage alloc] initWithImage:self];
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:kCIInputImageKey,imageToBlur ,nil];
    [filter setValue:@(blur) forKey:@"inputRadius"];
    CIImage *outputImage = [filter outputImage];
    
    // NOTE: adjust rect because blur changed size of image
    CGRect rect = [outputImage extent];
    rect.origin.x += (rect.size.width  - self.size.width ) / 2;
    rect.origin.y += (rect.size.height - self.size.height) / 2;
    rect.size  = self.size;
    return [UIImage imageWithCGImage:[context createCGImage:outputImage fromRect:rect]];
}

- (UIImage *)rotateToOrientation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect      rect = CGRectZero;
    float       translateX = 0;
    float       translateY = 0;
    float       scaleX = 1.0;
    float       scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width / rect.size.height;
            scaleX = rect.size.height / rect.size.width;
            break;
            
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, self.size.height, self.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width / rect.size.height;
            scaleX = rect.size.height / rect.size.width;
            break;
            
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
            
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, self.size.width, self.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
    
    return UIGraphicsGetImageFromCurrentImageContext();
}


@end
