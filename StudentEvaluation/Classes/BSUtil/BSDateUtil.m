//
//  DateUtil.m
//  WuHan_GJJ
//
//  Created by chinda021 on 16/2/2.
//  Copyright © 2016年 chinda021. All rights reserved.
//

#import "BSDateUtil.h"

@implementation BSDateUtil

+ (NSInteger)dayFromDate:(NSDate *)date
{
    NSCalendar          *calendar = [NSCalendar currentCalendar];
    NSDateComponents    *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    return [components day];
}

+ (NSInteger)monthFromDate:(NSDate *)date
{
    NSCalendar          *calendar = [NSCalendar currentCalendar];
    NSDateComponents    *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    return [components month];
}

+ (NSInteger)yearFromDate:(NSDate *)date
{
    NSCalendar          *calendar = [NSCalendar currentCalendar];
    NSDateComponents    *components = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    
    return [components year];
}

+ (NSString *)localizedWeekDayStringFromDate:(NSDate *)date
{
    NSString *day = nil;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E"];
    NSString *locationString = [formatter stringFromDate:date];
    
    if ([locationString isEqualToString:@"Mon"] || [locationString isEqualToString:@"周一"]) {
        day = @"星期一";
    } else if ([locationString isEqualToString:@"Tue"] || [locationString isEqualToString:@"周二"]) {
        day = @"星期二";
    } else if ([locationString isEqualToString:@"Wed"] || [locationString isEqualToString:@"周三"]) {
        day = @"星期三";
    } else if ([locationString isEqualToString:@"Thu"] || [locationString isEqualToString:@"周四"]) {
        day = @"星期四";
    } else if ([locationString isEqualToString:@"Fri"] || [locationString isEqualToString:@"周五"]) {
        day = @"星期五";
    } else if ([locationString isEqualToString:@"Sat"] || [locationString isEqualToString:@"周六"]) {
        day = @"星期六";
    } else if ([locationString isEqualToString:@"Sun"] || [locationString isEqualToString:@"周日"]) {
        day = @"星期天";
    }
    
    return day;
}

+ (NSArray *)startAndEndDateOWeekForDate:(NSDate *)date
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger dayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday];
    [components setDay:([components day] - ((dayofweek) - 2))];
    
    NSDate *beginningOfWeek = [gregorian dateFromComponents:components];
    NSString *dateString2Prev = [dateFormat stringFromDate:beginningOfWeek];
    NSDate *start = [dateFormat dateFromString:dateString2Prev];
    
    NSCalendar *gregorianEnd = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *componentsEnd = [gregorian components:NSCalendarUnitWeekday | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger Enddayofweek = [[[NSCalendar currentCalendar] components:NSCalendarUnitWeekday fromDate:date] weekday];
    [componentsEnd setDay:([componentsEnd day] + (7-Enddayofweek) + 1)];
    
    NSDate *EndOfWeek = [gregorianEnd dateFromComponents:componentsEnd];
    NSString *dateEndPrev = [dateFormat stringFromDate:EndOfWeek];
    
    NSDate *end = [dateFormat dateFromString:dateEndPrev];
    
    return @[start, end];
}

+ (NSString *)intervalSinceNowFromDate:(NSDate *)date
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    NSString        *timeString = nil;
    
    if (![self isDateInCurrentYear:date] || interval < 0) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        return [formatter stringFromDate:date];
    }
    
    if (interval < 60) {
        timeString = @"刚刚";
    } else if (interval >= 60 && interval < 60 * 60) {
        timeString = [NSString stringWithFormat:@"%ld分钟前",(NSInteger)interval / 60];
    } else if (interval >= 60 * 60 && interval < 60 * 60 * 24) {
        timeString = [NSString stringWithFormat:@"%ld小时前", (NSInteger)interval / (60 * 60)];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"MM-dd";
        timeString = [formatter stringFromDate:date];
    }
    
    return timeString;
}

+ (NSString *)dateStringWithWeekFromDate:(NSDate *)date
{
    BOOL isCurrentYear = [self isDateInCurrentYear:date];
    NSString *style = isCurrentYear ? @"MM-dd EEEE" : @"yyyy-MM-dd EEEE";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = style;
    
    return [formatter stringFromDate:date];
}

+ (NSString *)dateStringForMomentFromDate:(NSDate *)date
{
    NSString *style = @"yyyy-MM-dd HH:mm";
    if ([self isToday:date]) {
        style = @"HH:mm";
    } else if ([self isDateInCurrentYear:date]) {
        style = @"MM-dd HH:mm";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:style];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateStringForCommonFromDate:(NSDate *)date
{
    NSString *style = @"yyyy-MM-dd";
    if ([self isDateInCurrentYear:date]) {
        style = @"MM-dd";
    }
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:style];
    
    return [dateFormatter stringFromDate:date];
}

+ (NSString *)dateStringForStyle:(BSDateFormateStyle)style date:(NSDate *)date
{
    switch (style) {
        case BSDateFormateStyleFresh:
        {
            return [self intervalSinceNowFromDate:date];
        }
        case BSDateFormateStylePlanCycle:
        {
            return [self dateStringWithWeekFromDate:date];
        }
        case BSDateFormateStyleMoment:
        {
            return [self dateStringForMomentFromDate:date];
        }
        default:
        {
            return [self dateStringForCommonFromDate:date];
        }
    }
}

+ (NSString *)stringFromDateString:(NSString *)dateString dateFormate:(NSString *)formatter
{
    if (!dateString || !formatter)  return nil;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *date = [dateFormatter dateFromString:dateString];
    dateFormatter.dateFormat = formatter;
    return [dateFormatter stringFromDate:date];
}

+ (BOOL)isDateInCurrentYear:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy";
    
    NSString *currentYear = [formatter stringFromDate:[NSDate date]];
    NSString *targetYear = [formatter stringFromDate:date];
    
    return [currentYear isEqualToString:targetYear];
}

+ (BOOL)isToday:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"MM-dd";
    NSString *currentDay = [formatter stringFromDate:[NSDate date]];
    NSString *targetDay = [formatter stringFromDate:date];
    
    return [currentDay isEqualToString:targetDay] && [self isDateInCurrentYear:date];
}

+ (NSString *)intervalStringFromDate:(NSDate *)date
{
    NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:date];
    NSString        *timeString = nil;
    
    if (interval < 60) {
        timeString = @"刚刚";
    } else if (interval >= 60 && interval < 60 * 60) {
        timeString = [NSString stringWithFormat:@"%ld分钟前",(NSInteger)interval / 60];
    } else if (interval >= 60 * 60 && interval < 60 * 60 * 24) {
        timeString = [NSString stringWithFormat:@"%ld小时前", (NSInteger)interval / (60 * 60)];
    } else if (interval >= 60 * 60 * 24 && interval < 60 * 60 * 24 * 30) {
        timeString = [NSString stringWithFormat:@"%ld天前", (NSInteger)interval / (60 * 60 * 24)];
    } else if (interval >= 60 * 60 * 24 * 30 && interval < 60 * 60 * 24 * 30 * 12) {
        timeString = [NSString stringWithFormat:@"%ld月前", (NSInteger)interval / (60 * 60 * 24 * 30)];
    } else {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyy-MM-dd";
        timeString = [formatter stringFromDate:date];
    }
    
    return timeString;
}

@end
