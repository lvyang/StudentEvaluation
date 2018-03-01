//
//  BSErrorPage.h
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/12/11.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM (NSInteger, BSErrorPageType) {
    BSErrorPageTypeDownloadError,   // 网络加载错误
    BSErrorPageTypeNoNetworking,    // 无网络
    BSErrorPageTypeNoData           // 网络正常，但是数据为空
};

@interface BSErrorPage : UIView

@property (weak, nonatomic) IBOutlet UILabel    *textLabel;
@property (weak, nonatomic) IBOutlet UIButton   *reloadButton;

@property (nonatomic, assign) BSErrorPageType   type;
@property (nonatomic, assign) CGFloat           topPadding;

- (void)addReloadTarget:(id)target selector:(SEL)selector object:(id)object;

@end
