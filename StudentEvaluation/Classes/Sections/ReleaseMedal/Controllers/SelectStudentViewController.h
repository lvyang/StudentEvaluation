//
//  SelectStudentViewController.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/9.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "LYBaseViewController.h"
#import "BSViewController.h"

@protocol SelectStudentViewControllerDelegate<NSObject>

- (void)didSelectedStudent:(NSArray *)students;

@end

@interface SelectStudentViewController : BSViewController

@property (nonatomic, weak) id <SelectStudentViewControllerDelegate> delegate;

@end
