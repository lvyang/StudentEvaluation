//
//  StringUtil.h
//  WuHan_GJJ
//
//  Created by chinda021 on 16/1/26.
//  Copyright © 2016年 chinda021. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 字符串处理工具类 
 */
@interface BSStringUtil : NSObject

/**
 *  @description: 判断字符串是否为合法的数字。e.g.  1.12.3非法，12e非法
 */
+ (BOOL)isValidateNumberString:(NSString *)text;

/**
 *  判断字符串是否全为数字
 */
+ (BOOL)isDigitOnly:(NSString *)str;

/**
 * @description: 判断是否是合法的纯整形字符串
 */
+ (BOOL)isValidateIntegerString:(NSString*)string;

/**
 * @description: 判断是否是合法的纯浮点型字符串
 */
+ (BOOL)isValidateFloatString:(NSString*)string;

/**
 *  @description: 判断邮箱是否合法
 */
+ (BOOL)isValidateEmail:(NSString *)email;

/**
 *  @description: 判断url是否合法
 */
+ (BOOL)isValidateUrl:(NSString *)url;

/**
 *  @description: 判断图片url是否合法
 */
+ (BOOL)isValidateImageUrl:(NSString *)url;

/**
 *  @description: 判读电话号码是否合法
 */
+ (BOOL)isValidatePhoneNumber:(NSString *)phone;

/**
 *  @description: 对字符串进行MD5加密
 */
+ (NSString *) md5String:(NSString *)str;

/**
 *  @description: 对电话号码进行加密,如 13888881234 --> 138****1234
 */
+ (NSString *)encriptPhoneNumber:(NSString *)phoneNumber;

/**
 *  @description: 对邮箱进行加密。例如： 123456789@qq.com  -->  123***@qq.com
 */
+ (NSString *)encriptEmail:(NSString *)sourceEmail;


/**
 *  @description: 对某个字符串中的自字符串进行高亮处理
 *
 *  @param subString  需要高亮处理的自字符串
 *  @param defaultAttribute  字符串默认属性集合
 *  @param str        初始字符串
 *  @param attributs  需要高亮处理的自字符串属性集合
 *
 *  @return: 处理过的字符串
 */
+ (NSAttributedString *)stringByHighlightSubString:(NSString *)subString withDefaultAttribute:(NSDictionary *)defaultAttribute sourceString:(NSString *)str withAttribute:(NSDictionary *)attributs;

/**
 *  @description: 出去浮点型字符串末尾无意义的0  如 @“1.20” -> @"1.2"
 *
 *  @param originalString  初始字符串
 *
 *  @return: 处理过后的字符串
 */
+ (NSString *)stringByTrimmingTrailZero:(NSString *)originalString;

/**
 *  @description 获取字符串所占的空间，此处只考虑两种情况：1. 限制宽，但是不限制高； 2. 限制高，但是不限制宽
 *
 *  @param string  需要计算空间的字符串
 *  @param font    字符串的字体
 *  @param width   限制字符串的宽，如果为0，就默认为字符串只有一行，不限制宽，高度根font推算；
 *                  如果不为0，则认为宽度固定，可以换行，高度不限
 *
 *  @return: 字符串所占size
 */
+ (CGSize) sizeForString:(NSString *)string font:(UIFont *)font limitWidth:(CGFloat)width;


/**
 * @description使用正则表达式找出所有的html标签，并删除
 *
 * @param str  带有html标签的原始字符串
 *
 * @return 经过处理的不带html标签的字符串
 */
+ (NSString *)stringByRemoveHtmlTag:(NSString *)str;

/**
 *  @description: 根据缩略图地址取原图地址，处理逻辑：
 *                缩略图地址：http://images.dev.dodoedu.com/resize/145x145/image/20161467616957-17151-3958-7638.png
 *                则原图地址：http://images.dev.dodoedu.com/image/20161467616957-17151-3958-7638.png
 *
 *  @param thumnailString  缩略图地址
 *
 *  @return 原图url
 */
+ (NSURL *)originalImageUrlFromThumnailUrlString:(NSString *)thumnailString;


/**
 *  @description: 从图片url中抓取图片尺寸
 *  例如： urlString = http://images.dev.dodoedu.com/resize/320x320/image/20161470798209-1227477-1491-6230.png  抓取的图片尺寸为（320，320）
 */
+ (CGSize)imageSizeFromImageUrl:(NSString *)urlString;
/**
 *  @description: 去掉目标字符串尾部的指定字符串，替换指定字符串为空，直至尾部不再是指定字符串
 *
 *  @param deleteStr  需要被去掉的字符串
 *  @param string  操作目标字符串
 *
 *  @return: 去掉目标字符串尾部的指定字符串的后的字符串
 */
+ (NSString *)stringDeleteTail:(NSString *)deleteStr  targetString:(NSString *)string;

/**
 *  @description 将 NSTimerInterval 转换为 形如: 00:00:00 的字符串
 */
+ (NSString *)timeStringFromInterval:(NSTimeInterval)interval;

/**
 *  @description 获取url的参数
 */
+ (NSDictionary *)parametersFromUrl:(NSString *)urlString;

/**
 *  @description 将阿拉伯数字转换为汉字
 */
+ (NSString *)chineseNumberStringFromArabNumberString:(NSString *)ArabNumberString;

/**
 *  @description 汉字转拼音
 */
+ (NSString *)pinyinFromChinese:(NSString *)chinese lowercase:(BOOL)lowercase;

@end
