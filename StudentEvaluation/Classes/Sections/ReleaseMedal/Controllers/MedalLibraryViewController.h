//
//  MedalLibraryViewController.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/2.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "BSViewController.h"
#import "BSMedalModel.h"

@protocol MedalLibraryViewControllerDelegate <NSObject>

- (void)frequentMedalChanged:(MedalType)type;

@end

@interface MedalLibraryViewController : BSViewController

@property (nonatomic, assign) MedalType medalType;

@property (nonatomic, assign) id <MedalLibraryViewControllerDelegate> delegate;

@end
