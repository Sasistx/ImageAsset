//
//  UIImage+CropImage.h
//  BaiduTong
//
//  Created by baidu on 14/11/17.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ELCDefines.h"

@interface UIImage (CropImage)
- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height;
+ (UIImage*)cropImageFromView:(UIView*)orgView;
@end
