//
//  ClassListViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/3/5.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "ClassListViewController.h"
#import "ClassListTableView.h"
#import "DataManager.h"
#import "BSLoginManager.h"

@interface ClassListViewController ()

@property (nonatomic, strong) ClassListTableView *tableView;

@end

@implementation ClassListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择班级";
    
    // table view
    {
        self.tableView = [[ClassListTableView alloc] initWithFrame:self.view.bounds];
        self.tableView.showsVerticalScrollIndicator = NO;
        [self.view addSubview:self.tableView];
        
        [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).with.offset(14);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(0);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
        
        __weak typeof(self) weakSelf = self;
        self.tableView.cellSelectedHandler = ^(UITableView *tableView, NSIndexPath *indexPath, id dataModel) {
            if ([DataManager shareManager].currentClass != dataModel) {
                [DataManager shareManager].currentClass = dataModel;
                [weakSelf.tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:SELECTED_CLASS_CHANGED object:nil userInfo:nil];
            }
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        };
        
        [self loadClassList];
    }
}

- (void)loadClassList
{
    if ([DataManager shareManager].classList.count) {
        self.tableView.selectedClass = [DataManager shareManager].currentClass;
        [self.tableView.items setArray:[DataManager shareManager].classList];
        [self.tableView reloadData];
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    [self showLoadingProgress:nil];
    [NetworkManager classListForTeacherId:[BSLoginManager shareManager].userModel.userId completed:^(NSError *error, NSArray *result) {
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hideLoadingProgress];
        
        if (error) {
            [strongSelf showPrompt:error.localizedDescription];
            return ;
        }
        
        [DataManager shareManager].classList = result;
        BSClassModel *model = result.firstObject;
        [DataManager shareManager].currentClass = model;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:SELECTED_CLASS_CHANGED object:nil userInfo:nil];
    }];
}


@end
