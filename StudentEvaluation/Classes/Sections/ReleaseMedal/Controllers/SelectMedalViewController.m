//
//  ReleaseMedalViewController.m
//  StudentEvaluation
//
//  Created by Yang.Lv on 2018/2/28.
//  Copyright © 2018年 bosheng. All rights reserved.
//

#import "SelectMedalViewController.h"
#import "SelectMedalCollectionView.h"
#import "NetworkManager.h"
#import "BSLoginManager.h"
#import <Masonry.h>
#import "BSMedalModel.h"
#import "BSClassModel.h"
#import "DataManager.h"
#import "MedalLibraryViewController.h"
#import "ClassListViewController.h"
#import "ReleaseMedalViewController.h"

@interface SelectMedalViewController ()<MedalLibraryViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (nonatomic, strong) SelectMedalCollectionView *collectionView;

@end

@implementation SelectMedalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"选择勋章";
    [self removeBackButtonItem];
        
    __weak typeof(self) weakSelf = self;
    {
        self.collectionView = [[SelectMedalCollectionView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.collectionView];
        [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.segment.mas_bottom).with.offset(5);
            make.bottom.equalTo(self.view.mas_bottom).with.offset(-49);
            make.left.equalTo(self.view.mas_left).with.offset(0);
            make.right.equalTo(self.view.mas_right).with.offset(0);
        }];
        
        self.collectionView.cellSelectedHandler = ^(UICollectionView *collectionView, NSIndexPath *indexPath, id dataModel) {
            [weakSelf releaseMedal:dataModel];
        };
        
        self.collectionView.addMedalHandler = ^{
            [weakSelf medalLibrary];
        };
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectedClassChanged:) name:SELECTED_CLASS_CHANGED object:nil];
    
    [self loadClassList];
}

- (void)loadClassList
{
    __weak typeof(self) weakSelf = self;
    [self showLoadingProgress:nil];
    [NetworkManager classListForTeacherId:[BSLoginManager shareManager].userModel.userId completed:^(NSError *error, NSArray *result) {
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hideLoadingProgress];
        
        if (error) {
            [strongSelf showPrompt:error.localizedDescription];
            [self addRightBarButtonItem];
            return ;
        }
        
        [DataManager shareManager].classList = result;
        BSClassModel *model = result.firstObject;
        [DataManager shareManager].currentClass = model;
        [self addRightBarButtonItem];
        [strongSelf loadMedal:(strongSelf.segment.selectedSegmentIndex == 0 ? MedalTypePraise: MedalTypeCriticism) forClass:model.classId];
    }];
}

- (void)loadMedal:(MedalType)type forClass:(NSString *)classId
{
    
    __weak typeof(self) weakSelf = self;
    [self showLoadingProgress:nil];
    [[DataManager shareManager] loadMedal:type forClass:classId completed:^(NSError *error, NSArray *result) {
        typeof(weakSelf) strongSelf = weakSelf;
        [strongSelf hideLoadingProgress];
        
        if(error){
            [strongSelf showPrompt:error.localizedDescription];
            return ;
        }
        
        [strongSelf.collectionView.dataArray setArray:result];
        [strongSelf.collectionView reloadData];
    }];
}

- (void)addRightBarButtonItem
{
    NSString *className = [DataManager shareManager].currentClass.className;
    if (!className) {
        className = @"选择班级";
    }
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:className style:UIBarButtonItemStylePlain target:self action:@selector(classList)];
    self.navigationItem.rightBarButtonItem = rightItem;
    NSDictionary *attribute = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                NSForegroundColorAttributeName : [UIColor whiteColor]};
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:attribute forState:UIControlStateNormal];
}

- (IBAction)valueChanged:(id)sender
{
    BSClassModel *model = [DataManager shareManager].classList.firstObject;
    [self loadMedal:(self.segment.selectedSegmentIndex == 0 ? MedalTypePraise: MedalTypeCriticism) forClass:model.classId];
}

- (void)medalLibrary
{
    MedalLibraryViewController *vc = [[MedalLibraryViewController alloc] init];
    vc.delegate = self;
    vc.medalType = (self.segment.selectedSegmentIndex == 0 ? MedalTypePraise: MedalTypeCriticism);
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)releaseMedal:(BSMedalModel *)medal
{
    ReleaseMedalViewController *vc = [[ReleaseMedalViewController alloc] initWithNibName:nil bundle:nil];
    vc.model = medal;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)selectedClassChanged:(NSNotification *)notification
{
    [self addRightBarButtonItem];
    BSClassModel *model = [DataManager shareManager].currentClass;
    [self loadMedal:(self.segment.selectedSegmentIndex == 0 ? MedalTypePraise: MedalTypeCriticism) forClass:model.classId];
}

- (void)classList
{
    ClassListViewController *vc = [[ClassListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - MedalLibraryViewControllerDelegate
- (void)frequentMedalChanged:(MedalType)type
{
    [self valueChanged:self.segment];
}

@end
