//
//  QRCodeViewController.h
//  dodoedu
//
//  Created by admin zheng on 16/1/19.
//  Copyright © 2016年 bosu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSViewController.h"


@protocol QRCodeViewControllerDelegate <NSObject>

- (void)didScanCode:(NSString *)code;

@end


@interface QRCodeViewController : BSViewController
@property(nonatomic, assign) id<QRCodeViewControllerDelegate> delegate;
@end
