//
//  StringUtil.m
//  WuHan_GJJ
//
//  Created by chinda021 on 16/1/26.
//  Copyright © 2016年 chinda021. All rights reserved.
//

#import "BSStringUtil.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+HTML.h"

@implementation BSStringUtil

+ (BOOL)isValidateNumberString:(NSString *)text
{
    NSString *formatter = @"^([+-]?)(?:|0|[1-9]\\d*)(?:\\.\\d*)?$";
    
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", formatter] evaluateWithObject:text];
}

+ (BOOL)isDigitOnly:(NSString *)str
{
    NSCharacterSet *notDigits = [[NSCharacterSet decimalDigitCharacterSet] invertedSet];
    
    return [str rangeOfCharacterFromSet:notDigits].location == NSNotFound;
}

+ (BOOL)isValidateIntegerString:(NSString *)string
{
    NSScanner   *scan = [NSScanner scannerWithString:string];
    int         val = 0;
    
    return [scan scanInt:&val] && [scan isAtEnd];
}

+ (BOOL)isValidateFloatString:(NSString *)string
{
    NSScanner   *scan = [NSScanner scannerWithString:string];
    float       val = 0.0f;
    
    return [scan scanFloat:&val] && [scan isAtEnd];
}

+ (BOOL)isValidateEmail:(NSString *)email
{
    NSString    *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:email];
}

+ (BOOL)isValidateUrl:(NSString *)url
{
    if ([url isKindOfClass:[NSURL class]]) {
        url = [(NSURL *)url absoluteString];
    }
    
    if (![url isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    NSString    *regex = @"^(http://|https://)?((?:[A-Za-z0-9]+-[A-Za-z0-9]+|[A-Za-z0-9]+)\\.)+([A-Za-z]+)[/\?\\:]?.*$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [predicate evaluateWithObject:url];
}

+ (BOOL)isValidateImageUrl:(NSString *)url
{
    BOOL validate = [self isValidateUrl:url];
    
    if (!validate) {
        return NO;
    }
    
    if ([url hasSuffix:@"/"]) {
        return NO;
    }
    
    return YES;
}

+ (BOOL)isValidatePhoneNumber:(NSString *)phone
{
    phone = [phone stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (phone.length != 11) {
        return NO;
    }
    
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    
    /**
     * 电信号段正则表达式
     */
    NSString    *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL        isMatch1 = [pred1 evaluateWithObject:phone];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL        isMatch2 = [pred2 evaluateWithObject:phone];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL        isMatch3 = [pred3 evaluateWithObject:phone];
    
    return isMatch1 || isMatch2 || isMatch3;
}

+ (NSString *)md5String:(NSString *)str
{
    const char      *cStr = [str UTF8String];
    unsigned char   result[16];
    
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:@"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

+ (NSString *)encriptPhoneNumber:(NSString *)phoneNumber
{
    if (![phoneNumber isKindOfClass:[NSString class]] || (phoneNumber.length != 11)) {
        return phoneNumber;
    }
    
    NSRange range = NSMakeRange(3, 4);
    return [phoneNumber.mutableCopy stringByReplacingCharactersInRange:range withString:@"****"];
}

+ (NSString *)encriptEmail:(NSString *)sourceEmail
{
    if (![self isValidateEmail:sourceEmail]) {
        return sourceEmail;
    }
    
    NSMutableArray  *components = [sourceEmail componentsSeparatedByString:@"@"].mutableCopy;
    NSString        *identifier = components.firstObject;
    
    if (identifier.length <= 3) {
        return sourceEmail;
    }
    
    NSString *encriptStr = [NSString stringWithFormat:@"%@***", [identifier substringWithRange:NSMakeRange(0, 3)]];
    [components replaceObjectAtIndex:0 withObject:encriptStr];
    return [components componentsJoinedByString:@"@"];
}

+ (NSAttributedString *)stringByHighlightSubString:(NSString *)subString withDefaultAttribute:(NSDictionary *)defaultAttribute sourceString:(NSString *)str withAttribute:(NSDictionary *)attributs
{
    if (!str) {
        return nil;
    }
    
    if (subString.length == 0) {
        return [[NSAttributedString alloc] initWithString:str attributes:defaultAttribute];
    }
    
    NSRange range = [str rangeOfString:subString options:NSCaseInsensitiveSearch];
    
    if (range.location == NSNotFound) {
        return [[NSAttributedString alloc] initWithString:str attributes:defaultAttribute];
    }
    
    NSUInteger                  maxRange = NSMaxRange(range);
    NSString                    *string1 = [str substringToIndex:maxRange];
    NSMutableAttributedString   *attributeString = [[NSMutableAttributedString alloc] initWithString:string1 attributes:defaultAttribute];
    [attributeString addAttributes:attributs range:range];
    
    [attributeString appendAttributedString:[self stringByHighlightSubString:subString withDefaultAttribute:defaultAttribute sourceString:[str substringFromIndex:maxRange] withAttribute:attributs]];
    
    return attributeString;
}

+ (NSString *)stringByTrimmingTrailZero:(NSString *)originalString
{
    if ((originalString.length == 0) || ([originalString rangeOfString:@"."].location == NSNotFound)) {
        return originalString;
    }
    
    if (([originalString characterAtIndex:originalString.length - 1] == '0')
        || ([originalString characterAtIndex:originalString.length - 1] == '.')) {
        NSString *newString = [originalString.mutableCopy substringToIndex:originalString.length - 2];
        return [BSStringUtil stringByTrimmingTrailZero:newString];
    }
    
    return originalString;
}

+ (CGSize)sizeForString:(NSString *)string font:(UIFont *)font limitWidth:(CGFloat)width
{
    CGFloat             lineHeight = font.lineHeight;
    CGSize              constrainSize = CGSizeZero;
    NSMutableDictionary *attribute = [NSMutableDictionary dictionary];
    
    if (fabs(width) < FLT_EPSILON) { // 传0的话认为不限制宽度
        constrainSize = CGSizeMake(INT_MAX, lineHeight);
    } else {
        constrainSize = CGSizeMake(width, INT_MAX);
    }
    
    if (font) {
        [attribute setObject:font forKey:NSFontAttributeName];
    }
    
    CGSize size = [string boundingRectWithSize:constrainSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil].size;
    return size;
}

+ (NSString *)stringByRemoveHtmlTag:(NSString *)str
{
    if (!str) {
        return nil;
    }
    
    str = [str stringByDecodingHTMLEntities];
    
    NSError             *error = nil;
    NSMutableString     *string = [str mutableCopy];
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"<[^>]*(>*)" options:0 error:&error];
    
    if (expression) {
        NSArray *result = [expression matchesInString:str options:0 range:NSMakeRange(0, [str length])];
        
        for (int i = 0; i < result.count; i++) {
            NSTextCheckingResult    *textCheckingResult = result[result.count - i - 1];
            NSRange                 range = [textCheckingResult rangeAtIndex:0];
            [string replaceCharactersInRange:range withString:@""];
        }
    }
    
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

+ (NSURL *)originalImageUrlFromThumnailUrlString:(NSString *)thumnailString
{
    if (!thumnailString.length) {
        return nil;
    }
    
    NSError             *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"/resize/\\d+x\\d+/" options:0 error:&error];
    
    if (expression) {
        NSArray *result = [expression matchesInString:thumnailString options:0 range:NSMakeRange(0, [thumnailString length])];
        
        if (!result.count) {
            return [NSURL URLWithString:thumnailString];
        }
        
        NSMutableString *string = thumnailString.mutableCopy;
        
        for (int i = 0; i < result.count; i++) {
            NSTextCheckingResult    *textCheckingResult = result[result.count - i - 1];
            NSRange                 range = [textCheckingResult rangeAtIndex:0];
            [string replaceCharactersInRange:NSMakeRange(range.location, range.length - 1) withString:@""];
        }
        
        return [NSURL URLWithString:string];
    }
    
    return [NSURL URLWithString:thumnailString];
}

+ (CGSize)imageSizeFromImageUrl:(NSString *)urlString
{
    CGSize              defaultImageSize = CGSizeZero;
    NSError             *error = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:@"/\\d+x\\d+/" options:0 error:&error];
    
    if (expression) {
        NSArray *result = [expression matchesInString:urlString options:0 range:NSMakeRange(0, [urlString length])];
        
        if (result.count == 0) {
            return defaultImageSize;
        }
        
        NSTextCheckingResult    *textCheckingResult = result.firstObject;
        NSRange                 range = [textCheckingResult rangeAtIndex:0];
        NSString                *sizeString = [urlString substringWithRange:NSMakeRange(range.location + 1, range.length - 2)];
        NSArray                 *arr = [sizeString componentsSeparatedByString:@"x"];
        CGFloat                 width = [arr.firstObject floatValue];
        CGFloat                 height = [arr.lastObject floatValue];
        
        return CGSizeMake(width, height);
    }
    
    return defaultImageSize;
}

+ (NSString *)stringDeleteTail:(NSString *)deleteStr targetString:(NSString *)string
{
    NSMutableString *tempString = [[NSMutableString alloc] initWithString:string];
    BOOL            finish = NO;
    
    while (!finish) {
        if (deleteStr.length > tempString.length) {
            finish = YES;
            continue;
        }
        
        NSString    *tailStr = [tempString substringFromIndex:tempString.length - deleteStr.length];
        NSRange     tailRange = NSMakeRange(tempString.length - deleteStr.length, deleteStr.length);
        
        if ([tailStr isEqualToString:deleteStr]) {
            [tempString replaceCharactersInRange:tailRange withString:@""];
        } else {
            finish = YES;
        }
    }
    
    return tempString;
}

+ (NSString *)timeStringFromInterval:(NSTimeInterval)interval
{
    int hours = interval / 3600;
    int minutes = ((NSInteger)interval / 60) % 60;
    int secs = (NSInteger)interval % 60;
    
    if (hours <= 0) {
        return [NSString stringWithFormat:@"%02d:%02d", minutes, secs];
    }
    
    return [NSString stringWithFormat:@"%01d:%02d:%02d", hours, minutes, secs];
}

+ (NSDictionary *)parametersFromUrl:(NSString *)urlString
{
    NSRange range = [urlString rangeOfString:@"?"];
    
    if (range.location == NSNotFound) {
        return nil;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString            *parametersString = [urlString substringFromIndex:range.location + 1];
    
    if ([parametersString containsString:@"&"]) {
        NSArray *urlComponents = [parametersString componentsSeparatedByString:@"&"];
        
        for (NSString *keyValuePair in urlComponents) {
            NSArray     *pairComponents = [keyValuePair componentsSeparatedByString:@"="];
            NSString    *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
            NSString    *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
            
            if ((key == nil) || (value == nil)) {
                continue;
            }
            
            id existValue = [params valueForKey:key];
            
            if (existValue != nil) {
                if ([existValue isKindOfClass:[NSArray class]]) {
                    NSMutableArray *items = [NSMutableArray arrayWithArray:existValue];
                    [items addObject:value];
                    [params setValue:items forKey:key];
                } else {
                    [params setValue:@[existValue, value] forKey:key];
                }
            } else {
                [params setValue:value forKey:key];
            }
        }
    } else {
        NSArray *pairComponents = [parametersString componentsSeparatedByString:@"="];
        
        if (pairComponents.count == 1) {
            return nil;
        }
        
        NSString    *key = [pairComponents.firstObject stringByRemovingPercentEncoding];
        NSString    *value = [pairComponents.lastObject stringByRemovingPercentEncoding];
        
        if ((key == nil) || (value == nil)) {
            return nil;
        }
        
        [params setValue:value forKey:key];
    }
    
    return params;
}

+ (NSString *)chineseNumberStringFromArabNumberString:(NSString *)ArabNumberString
{
    NSArray *Arab_numbers = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"0"];
    NSArray *chinese_strs = @[@"一", @"二", @"三", @"四", @"五", @"六", @"七", @"八", @"九", @"〇"];
    NSArray *digits = @[@"", @"十", @"百", @"千", @"万", @"十", @"百", @"千", @"亿", @"十", @"百", @"千", @"兆"];
    
    NSDictionary    *numberMap = [NSDictionary dictionaryWithObjects:chinese_strs forKeys:Arab_numbers];
    NSMutableArray  *sums = [NSMutableArray array];
    
    for (int i = 0; i < ArabNumberString.length; i++) {
        NSString    *subStr = [ArabNumberString substringWithRange:NSMakeRange(i, 1)];
        NSString    *a = [numberMap objectForKey:subStr];
        NSString    *b = digits[ArabNumberString.length - i - 1];
        NSString    *sum = [a stringByAppendingString:b];
        
        if ([a isEqualToString:chinese_strs[9]]) {
            if ([b isEqualToString:digits[4]] || [b isEqualToString:digits[8]]) {
                sum = b;
                
                if ([[sums lastObject] isEqualToString:chinese_strs[9]]) {
                    [sums removeLastObject];
                }
            } else {
                sum = chinese_strs[9];
            }
            
            if ([[sums lastObject] isEqualToString:sum]) {
                continue;
            }
        }
        
        [sums addObject:sum];
    }
    
    NSString *result = [sums componentsJoinedByString:@""];
    
    if ([result hasPrefix:@"一十"]) {
        result = [result substringFromIndex:1];
    }
    
    return result;
}

@end
