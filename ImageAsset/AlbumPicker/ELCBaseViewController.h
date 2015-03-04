//
//  ELCBaseViewController.h
//  BaiduTong
//
//  Created by baidu on 14-5-20.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ELCBaseViewController : UIViewController
@property (nonatomic, strong) UILabel* navigationBarTitle;
- (void)initialNavigationItem;
- (void)btnBackClick:(id)sender;
@end
