//
//  BSRecordView.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/8.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BSRecordView;

@protocol BSRecordViewDelegate <NSObject>

- (void)recordView:(BSRecordView *)recordView recordFinished:(NSString *)filePath error:(NSError *)error;

@end

@interface BSRecordView : UIControl

@property (nonatomic, strong) id <BSRecordViewDelegate> delegate;

- (void)show;
- (void)hide;

@end
