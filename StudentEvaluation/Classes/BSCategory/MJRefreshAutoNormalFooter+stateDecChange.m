//
//  MJRefreshAutoNormalFooter+stateDecChange.m
//  Pods
//
//  Created by admin zheng on 2017/5/12.
//
//

#import "MJRefreshAutoNormalFooter+stateDecChange.h"
#import "UIColor+Hex.h"

@implementation MJRefreshAutoNormalFooter (stateDecChange)

- (void)prepare
{
  
    [super prepare];
    
    if ([self isKindOfClass:[MJRefreshAutoNormalFooter class]]) {
        MJRefreshAutoNormalFooter * foot = (MJRefreshAutoNormalFooter *)self;
        [foot setTitle:@"到底啦~" forState:MJRefreshStateNoMoreData];
        [foot setTitle:@"" forState:MJRefreshStateIdle];
        [foot setTitle:@"查看更多" forState:MJRefreshStatePulling];
        self.stateLabel.textColor = [UIColor colorWithHexString:@"#969696"];
        self.stateLabel.font = [UIFont systemFontOfSize:13];
    }
    
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
}

@end
