//
//  BSMedalModel.h
//  BSCourseModule
//
//  Created by Yang.Lv on 2017/4/17.
//  Copyright © 2017年 lvyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

typedef NS_ENUM(NSInteger, MedalType) {
    MedalTypeCriticism,
    MedalTypePraise
};

/**
 * 勋章model
 */
@interface BSMedalModel : NSObject

@property (nonatomic, strong) NSNumber  *identifier;        // 勋章ID
@property (nonatomic, assign) MedalType medalType;          // 勋章类型
@property (nonatomic, strong) NSString  *medalName;         // 勋章名称
@property (nonatomic, strong) NSString  *medalIcon;         // 勋章图标

@property (nonatomic, strong) NSNumber  *medalFieldId;      // 维度ID
@property (nonatomic, strong) NSString  *medalFieldName;    // 维度名称

@end
