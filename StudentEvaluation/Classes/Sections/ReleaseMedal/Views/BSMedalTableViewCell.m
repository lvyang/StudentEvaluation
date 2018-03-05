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

static CGFloat MEDAL_ICON_WIDTH = 67;
static CGFloat MEDAL_ICON_HEIGHT = 67;

static CGFloat MEDAL_TITLE_HEIGHT = 13;

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
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(x + 5, 8, MEDAL_ICON_HEIGHT + 15, MEDAL_ICON_HEIGHT + MEDAL_TITLE_HEIGHT + 26)];
        bgView.tag = i + 1;
        bgView.backgroundColor = [UIColor whiteColor];
        [self.scrollView addSubview:bgView];
        
        BSMedalModel *model = data[i];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake((bgView.frame.size.width - MEDAL_ICON_WIDTH) / 2, 10, MEDAL_ICON_WIDTH, MEDAL_ICON_HEIGHT);
        NSString *urlString = model.medalIcon ? : @"";
        [button sd_setImageWithURL:[NSURL URLWithString:urlString] forState:UIControlStateNormal placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [bgView addSubview:button];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 8, bgView.frame.size.width, MEDAL_TITLE_HEIGHT)];
        label.font = [UIFont systemFontOfSize:12];
        label.textColor = [UIColor colorWithHexString:@"5a5a5a"];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = model.medalName;
        [bgView addSubview:label];
        
        UIImage *image = [UIImage imageNamed:@"xiugaimima_icon_mimakejian_sal.png"];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(bgView.width - 20, 6, 14, 14)];
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
    
    bgView.layer.borderColor = [UIColor colorWithRed:83/255.0 green:193/255.0 blue:205/255.0 alpha:1].CGColor;
    bgView.layer.borderWidth = 0.5;
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
    
    bgView.layer.borderColor = [UIColor clearColor].CGColor;
    bgView.layer.borderWidth = 0.5;
    [bgView viewWithTag:IMAGE_VIEW_INDICATOR_TAG].hidden = YES;
}

+ (CGFloat)cellHeight
{
    return MEDAL_ICON_HEIGHT + MEDAL_TITLE_HEIGHT + 40;
}

@end
