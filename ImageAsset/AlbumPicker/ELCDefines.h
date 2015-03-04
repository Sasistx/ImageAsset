//
//  ELCDefines.h
//  ImageAsset
//
//  Created by baidu on 15/1/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#ifndef ImageAsset_ELCDefines_h
#define ImageAsset_ELCDefines_h

#define IsIOS6 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 6.0 && [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0)
#define IsIOS7 ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)

#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height

#define IsIPhone5 ((double)[[UIScreen mainScreen] bounds].size.height-(double)568 >= 0 - DBL_EPSILON)

#define CELL_IDENTIFIER @"AssetCell"

#endif
