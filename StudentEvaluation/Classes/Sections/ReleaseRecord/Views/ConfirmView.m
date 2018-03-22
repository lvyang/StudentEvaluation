//
//  ConfirmView.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/22.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ConfirmView.h"
#import "UIView+LayoutMethods.h"

@interface ConfirmView()

@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

@property (nonatomic, copy) void(^confirmHandler)(void);

@end

@implementation ConfirmView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.cancelButton.layer.cornerRadius = 5;
    self.cancelButton.layer.masksToBounds = YES;
    
    self.confirmButton.layer.cornerRadius = 5;
    self.confirmButton.layer.masksToBounds = YES;
    self.confirmButton.layer.borderColor = [UIColor colorWithRed:161/255.0 green:161/255.0 blue:161/255.0 alpha:1].CGColor;
    self.confirmButton.layer.borderWidth = 1;
    
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.masksToBounds = YES;
    
    [self addTarget:self action:@selector(tap) forControlEvents:UIControlEventTouchUpInside];
}

- (IBAction)confirm:(id)sender
{
    if (self.confirmHandler) {
        self.confirmHandler();
    }
    
    [self removeFromSuperview];
}

- (IBAction)cancel:(id)sender
{
    [self removeFromSuperview];
}

- (void)showWithConfirmBlock:(void(^)(void))confirm
{
    self.confirmHandler = confirm;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    self.frame = window.bounds;
    [window addSubview:self];
    
    self.contentView.y = self.bounds.size.height;
    self.contentView.centerX = self.width / 2;

    [UIView animateWithDuration:0.5 animations:^{
        self.contentView.centerY = self.bounds.size.height / 2;
    }];
}

- (void)tap
{
    [self removeFromSuperview];
}

@end
