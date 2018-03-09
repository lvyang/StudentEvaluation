//
//  BSTrack.m
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/10/10.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "BSTrack.h"

@implementation BSTrack

- (BOOL)isEqual:(BSTrack *)object
{
    if (![object isKindOfClass:[BSTrack class]]) {
        return NO;
    }
    
    if (object == self) {
        return YES;
    }
    
    return [self.identifier isEqualToString:object.identifier];
}

@end
