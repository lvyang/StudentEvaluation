//
//  VoiceListTableView.h
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/9.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VoiceListTableView : UITableView

/* table view's data source **/
@property(nonatomic, strong) NSMutableArray *items;

@property (nonatomic, copy) void(^addVoiceHandler)(void);

@end
