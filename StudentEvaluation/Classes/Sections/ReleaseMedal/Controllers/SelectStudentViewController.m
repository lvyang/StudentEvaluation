//
//  SelectStudentViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/9.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "SelectStudentViewController.h"
#import "StudentListTableView.h"
#import <Masonry.h>
#import "NetworkManager.h"
#import "BSClassModel.h"
#import "DataManager.h"

@interface SelectStudentViewController ()

@property (nonatomic, strong) StudentListTableView *tableView;

@end

@implementation SelectStudentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择班级";
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStylePlain target:self action:@selector(confirm)];
    self.navigationItem.rightBarButtonItem = rightItem;
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attribute forState:UIControlStateNormal];
    
    // table view
    {
        self.tableView = [[StudentListTableView alloc] initWithFrame:self.view.bounds];
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(0);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
    }
    
    [self loadData];
}

- (void)loadData
{
    [self showLoadingProgress:nil];
    
    BSClassModel *class = [DataManager shareManager].currentClass;
    [NetworkManager loadStudentsList:class.classId completed:^(NSError *error, NSArray *result, NSArray *keys) {
        [self hideLoadingProgress];
        
        if (error ) {
            [self showPrompt:error.localizedDescription];
            return ;
        }
        
        [self.tableView.items setArray:result];
        [self.tableView.keys setArray:keys];
        [self.tableView reloadData];
    }];
}

- (void)confirm
{
    if (self.tableView.selectedItems.count == 0) {
        [self showPrompt:@"请选择学生"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(didSelectedStudent:)]) {
        [self.delegate didSelectedStudent:self.tableView.selectedItems.allObjects];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
