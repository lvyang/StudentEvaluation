//
//  NSDictionary+SafeObject.m
//  Pods
//
//  Created by Yang.Lv on 2017/3/10.
//
//

#import "NSDictionary+SafeObject.h"

@implementation NSDictionary (SafeObject)

- (id)safeObjectForKey:(NSString *)key
{
    id object = [self objectForKey:key];
    
    return [object isKindOfClass:[NSNull class]] ? nil : object;
}

@end
