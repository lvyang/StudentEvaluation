//
//  BSWebviewViewController.h
//  Pods
//
//  Created by admin zheng on 2017/4/20.
//
//

#import <UIKit/UIKit.h>
#import "BSViewController.h"

@interface BSWebviewViewController : BSViewController

@property (weak, nonatomic) IBOutlet UIWebView    *webView;
@property (nonatomic, strong) UIColor             *naviBarColor;

- (id)initWithURLStr:(NSString *)urlStr;

@end
