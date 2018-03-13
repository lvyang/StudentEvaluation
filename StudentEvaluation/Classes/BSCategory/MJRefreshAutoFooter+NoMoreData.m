//
//  MJRefreshAutoFooter+NoMoreDataMangaer.m
//  dodoedu
//
//  Created by admin zheng on 2016/11/17.
//  Copyright © 2016年 bosu. All rights reserved.
//

#import "MJRefreshAutoFooter+NoMoreData.h"

@implementation MJRefreshAutoFooter (NoMoreDataMangaer)

- (void)endRefreshingWithNoMoreData
{
    self.state = MJRefreshStateNoMoreData;

    UILabel *stateLabel = nil;

    for (UILabel *label in self.subviews) {
        if ([label isKindOfClass:[UILabel class]]) {
            stateLabel = label;
            break;
        }
    }

    if (!stateLabel) {
        return;
    }

    if (_scrollView.mj_insetT + _scrollView.mj_contentH <= _scrollView.mj_h) {
        stateLabel.text = @"";
    }
}

@end
