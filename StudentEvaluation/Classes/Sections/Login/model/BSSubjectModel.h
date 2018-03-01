//
//  BSSubjectModel.h
//  BSModel
//
//  Created by Yang.Lv on 2017/3/16.
//  Copyright © 2017年 lvyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYModel.h"

/**
 *  科目对象
 */
@interface BSSubjectModel : NSObject

// 科目代码
@property (nonatomic, strong) NSString *code;
// 科目名称
@property (nonatomic, strong) NSString *name;

@end
