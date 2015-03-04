//
//  UIImage+CropImage.m
//  BaiduTong
//
//  Created by baidu on 14/11/17.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "UIImage+CropImage.h"

@implementation UIImage (CropImage)

- (UIImage *)cropImageWithX:(CGFloat)x y:(CGFloat)y width:(CGFloat)width height:(CGFloat)height {
    CGRect rect = CGRectMake(x, y, width, height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef];
    return image;
}

+ (UIImage*)cropImageFromView:(UIView*)orgView
{
    UIGraphicsBeginImageContext(orgView.bounds.size);
    [orgView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

@end
