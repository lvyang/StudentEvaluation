//
//  PhotoModel.h
//  dodoedu
//
//  Created by Yang.Lv on 16/9/27.
//  Copyright © 2016年 bosu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BSPhotoModel : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSNumber *photoId;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, assign) NSInteger favoriteCount;
@property (nonatomic, assign) NSInteger commentCount;
@property (nonatomic, assign) NSInteger myFavoriteStatus;

@end
