//
//  ConfirmView.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/22.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ConfirmView : UIControl

- (void)showWithConfirmBlock:(void(^)(void))confirm;

@end
