//
//  NSDictionary+SafeObject.h
//  Pods
//
//  Created by Yang.Lv on 2017/3/10.
//
//

#import <Foundation/Foundation.h>

@interface NSDictionary (SafeObject)

/**
 *  @description: 对objectForKey：方法的封装，如果键值为null，就返回nil
 */
- (id)safeObjectForKey:(NSString *)key;

@end
