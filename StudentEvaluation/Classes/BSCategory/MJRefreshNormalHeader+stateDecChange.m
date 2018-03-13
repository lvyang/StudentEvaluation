//
//  MJRefreshNormalHeader+stateDecChange.m
//  Pods
//
//  Created by admin zheng on 2017/5/12.
//
//

#import "MJRefreshNormalHeader+stateDecChange.h"
#import "UIColor+Hex.h"

@implementation MJRefreshNormalHeader (stateDecChange)

- (void)prepare
{
    [super prepare];
    
    [self setTitle:@"释放刷新" forState:MJRefreshStatePulling];
    self.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    self.lastUpdatedTimeLabel.textColor = [UIColor colorWithHexString:@"#969696"];
    self.lastUpdatedTimeLabel.font = [UIFont systemFontOfSize:13];
    self.stateLabel.textColor = [UIColor colorWithHexString:@"#969696"];
    self.stateLabel.font = [UIFont systemFontOfSize:13];
}

@end
