//
//  ELCBaseZoomScrollViewController.h
//  BaiduTong
//
//  Created by baidu on 14-5-20.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ELCAsset.h"

@interface ELCBaseZoomScrollViewController : UIViewController <UIScrollViewDelegate>
@property (nonatomic, assign, readonly) NSUInteger controllerIndex;
@property (nonatomic, assign) BOOL allowEdit;
@property (assign, nonatomic) CGSize cropSize;
@property (nonatomic, strong) UIScrollView* zoomScrollView;
@property (nonatomic, strong) UIImage *zoomImage;
@property (nonatomic, strong) UIImageView *zoomImageView;
- (instancetype)initWithImageID:(ELCAsset *)asset allowEdit:(BOOL)edit cropSzie:(CGSize)cropSize;
- (instancetype)initWithImageID:(ELCAsset *)asset withIndex:(NSUInteger)index;
@end
