//
//  DateUtil.h
//  WuHan_GJJ
//
//  Created by chinda021 on 16/2/2.
//  Copyright © 2016年 chinda021. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, BSDateFormateStyle) {
    BSDateFormateStyleFresh,            // 关注新鲜度
    BSDateFormateStylePlanCycle,        // 关注计划周期
    BSDateFormateStyleMoment,           // 关注时刻
    BSDateFormateStyleCommon            // 常规日期记录
};

@interface BSDateUtil : NSObject

/**
 *  @description: 获取指定日期所在的天
 *
 *  @param: date  指定的日期
 *
 *  @return: 日期所在的天
 */
+ (NSInteger)dayFromDate:(NSDate *)date;

/**
 *  @description: 获取指定日期所在的月份
 *
 *  @param: date  指定的日期
 *
 *  @return: 日期所在的月份
 */
+ (NSInteger)monthFromDate:(NSDate *)date;

/**
 *  @description: 获取指定日期所在的年份
 *
 *  @param: date  指定的日期
 *
 *  @return: 日期所在的年份
 */
+ (NSInteger)yearFromDate:(NSDate *)date;

/**
 *  @description: 判断日期是星期几
 */
+ (NSString *)localizedWeekDayStringFromDate:(NSDate *)date;

/**
 *  @description: 获取指定日期所在周的起始日期
 *
 *  @param: date  日期
 *
 *  @return: 形如[start<NSDate *>,end<NSDate *>]的数组,第一个对象为起始日期，第二个对象为终止日期
 */
+ (NSArray *)startAndEndDateOWeekForDate:(NSDate *)date;

/**
 *  @description: 将日期转换为距离当前时间的字符串，侧重关注新鲜度，适用：消息流，评论（留言）、问答。格式如下：
 *
 *  发生时间x               显示格式                示例
 *  x < 1min                刚刚                  刚刚
 *  1min<x<1h              X分钟前               5分钟前
 *  1h≤x<24h               X小时前               5小时前
 *  x＞24h，且在当前年份       MM-dd                03-15
 *  不在当前年份            yyyy-MM-dd           2015-03-15
 *
 *  @param: NSDate  日期
 *
 *  @return: 距离当前时间的字符串：刚刚、XX分钟前、XX天前等。
 */
+ (NSString *)intervalSinceNowFromDate:(NSDate *)date;

/**
 *  @description: 将NSDate对象转换为字符串，侧重关注计划周期,适用：消息流、评论（留言）、问答等，格式如下：
 *
 *  发生时间x               显示格式                示例
 *  当前年份              MM-dd 星期X            03-15 星期一
 *  非当前年份           yyyy-MM-dd 星期X	    2015-03-15 星期一
 */
+ (NSString *)dateStringWithWeekFromDate:(NSDate *)date;

/**
 *  @description: 将NSDate对象转换为指定格式的字符串，侧重关注时刻，适用：作业、学生评价等，格式如下
 *
 *  发生时间x               显示格式                示例
 *  当天                    hh:mm                 8:50
 *  当天之前，当前年份      MM-dd hh:mm            03-15 16:00
 *  非当前年份           yyyy-MM-dd hh:mm      2015-03-15 16:00
 */
+ (NSString *)dateStringForMomentFromDate:(NSDate *)date;

/**
 *  @description: 将NSDate对象转换为常规日期记录，适用：博客、相册、讨论、活动、投票调查、公告、阅读文章、资源库、通知、站内信、收藏
 *
 *  发生时间x               显示格式                示例
 *  当前年份                 MM-dd                03-15
 *  非当前年份             yyyy-MM-dd            2015-03-15
 
 */
+ (NSString *)dateStringForCommonFromDate:(NSDate *)date;

/**
 *  @description: 获取指定类型的日期字符串
 */
+ (NSString *)dateStringForStyle:(BSDateFormateStyle)style date:(NSDate *)date;

/**
 *  @description: 将日期类型为："yyyy-MM-dd HH:mm:ss"的字符串转为指定格式的日期字符串
 *
 *  @param: dateString  初始日期字符串
 *  @param: formatter  新日期的格式
 *
 *  @return: 转换后的字符串
 */
+ (NSString *)stringFromDateString:(NSString *)dateString dateFormate:(NSString *)formatter;

/**
 *  @description: 将日期转换为距离当前时间的字符串，侧重关注新鲜度，适用：消息流，评论（留言）、问答。格式如下：
 *
 *  发生时间x               显示格式                示例
 *  x < 1min                刚刚                  刚刚
 *  1min<x<1h              X分钟前               5分钟前
 *  1h≤x<24h               X小时前               5小时前
 *  24h≤x<30天              X天前                5天前
 *  30天≤x<1年              X月前                 5月前
 *  超过一年              yyyy-MM-dd             2015-03-15
 *
 *  @param: NSDate  日期
 *
 *  @return: 距离当前时间的字符串：刚刚、XX分钟前、XX天前等。
 */
+ (NSString *)intervalStringFromDate:(NSDate *)date;


@end
