//
//  BSUrlArgumentsFilter.h
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/9/23.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YTKNetworkConfig.h>

@interface BSUrlArgumentsFilter : NSObject <YTKUrlFilterProtocol>

+ (instancetype)filterWithArguments:(NSDictionary *)arguments;

@end
