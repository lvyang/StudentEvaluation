//
//  BSErrorPage.m
//  ClassicsReading
//
//  Created by Yang.Lv on 2017/12/11.
//  Copyright © 2017年 bosheng. All rights reserved.
//

#import "BSErrorPage.h"

@interface BSErrorPage ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textLabelTopPadding;

@property (nonatomic, assign) id    target;
@property (nonatomic, assign) SEL   selector;
@property (nonatomic, strong) id    object;

@end

@implementation BSErrorPage

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
}

- (void)addReloadTarget:(id)target selector:(SEL)selector object:(id)object
{
    _target = target;
    _selector = selector;
    _object = object;
}

- (void)setType:(BSErrorPageType)type
{
    switch (type) {
        case BSErrorPageTypeNoData:
        {
            self.textLabel.hidden = NO;
            self.reloadButton.hidden = YES;
            self.textLabel.text = @"没有数据";
            break;
        }
            
        case BSErrorPageTypeNoNetworking:
        case BSErrorPageTypeDownloadError:
        {
            self.textLabel.hidden = NO;
            self.reloadButton.hidden = NO;
            self.textLabel.text = @"网络加载失败";
            break;
        }
            
        default:
            break;
    }
}

- (void)setTopPadding:(CGFloat)topPadding
{
    _topPadding = topPadding;
    self.textLabelTopPadding.constant = topPadding;
}

- (IBAction)reload:(id)sender
{
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
    
    [_target performSelector:_selector withObject:_object];
    
#pragma clang diagnostic pop
}

@end
