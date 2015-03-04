//
//  ELCBaseViewController.m
//  BaiduTong
//
//  Created by baidu on 14-5-20.
//  Copyright (c) 2014年 Baidu. All rights reserved.
//

#import "ELCBaseViewController.h"

@interface ELCBaseViewController ()

@end

@implementation ELCBaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initialNavigationItem
{

}

#pragma mark - button click

- (void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
