//
//  MedalTableViewCell.m
//  生命安全教育
//
//  Created by Yang.Lv on 2017/2/10.
//  Copyright © 2017年 zhuchao. All rights reserved.
//

#import "BSMedalTableViewCell.h"
#import "UIButton+WebCache.h"
#import "BSMedalModel.h"
#import "UIColor+Hex.h"
#import "UIView+LayoutMethods.h"

static CGFloat MEDAL_ICON_WIDTH = 49;
static CGFloat MEDAL_ICON_HEIGHT = 48;

NSInteger IMAGE_VIEW_INDICATOR_TAG = 999;

@interface BSMedalTableViewCell ()

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *dataArray;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end

@implementation BSMedalTableViewCell

- (void)configureCellWithData:(NSArray *)data atIndexPath:(NSIndexPath *)indexPath
{
    _dataArray = data;
    _indexPath = indexPath;
    
    for (UIView *view in self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    CGFloat x = 0;
    for (int i = 0; i < data.count; i++) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x, 0, 75, 100)];
        bgView.tag = i + 1;
        bgView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:bgView];
        
        BSMedalModel *model = data[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((bgView.frame.size.width - MEDAL_ICON_WIDTH) / 2, 17, MEDAL_ICON_WIDTH, MEDAL_ICON_HEIGHT);
        NSString *urlString = model.medalIcon ? : @"";
        [button sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 8, bgView.frame.size.width, 13)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"5a5a5a"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = model.medalName;
        [bgView addSubview:label];
        
        UIImage *image = [UIImage imageNamed:@"kecheng_icon_check_3.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.frame.size.width - image.size.width - 5, 10, image.size.width, image.size.height)];
        imageView.image = image;
        [bgView addSubview:imageView];
        imageView.hidden = YES;
        imageView.tag = IMAGE_VIEW_INDICATOR_TAG;
        x = CGRectGetMaxX(bgView.frame);
    }
    
    self.scrollView.contentSize = CGSizeMake(x, self.scrollView.contentSize.height);
}

- (void)buttonClick:(UIButton *)sender
{
    if ([self.delegate respondsToSelector:@selector(medalTableViewCellAtIndexPath:didSelectedMedal:)]) {
        [self.delegate medalTableViewCellAtIndexPath:self.indexPath didSelectedMedal:self.dataArray[sender.superview.tag - 1]];
    }
    
    [self didSelectMedal:self.dataArray[sender.superview.tag - 1]];
}

- (void)didSelectMedal:(BSMedalModel *)model
{
    NSInteger index = [self.dataArray indexOfObject:model];
    if (index == NSNotFound) {
        return;
    }
    
    UIView *bgView = nil;
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag == index + 1) {
            bgView = view;
            break;
        }
    }
    
    bgView.backgroundColor = [UIColor colorWithHexString:@"f0f0f0"];
    [bgView viewWithTag:IMAGE_VIEW_INDICATOR_TAG].hidden = NO;
}

- (void)didDeselectMedal:(BSMedalModel *)model
{
    NSInteger index = [self.dataArray indexOfObject:model];
    if (index == NSNotFound) {
        return;
    }

    UIView *bgView = nil;
    for (UIView *view in self.scrollView.subviews) {
        if (view.tag == index + 1) {
            bgView = view;
            break;
        }
    }
    
    bgView.backgroundColor = [UIColor whiteColor];
    [bgView viewWithTag:IMAGE_VIEW_INDICATOR_TAG].hidden = YES;
}

@end
