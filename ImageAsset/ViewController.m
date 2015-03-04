//
//  ViewController.m
//  ImageAsset
//
//  Created by baidu on 15/1/26.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "ViewController.h"
#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
@interface ViewController ()
@property (nonatomic, strong) UIImageView* imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UIButton* button = [UIButton buttonWithType:UIButtonTypeSystem];
    [button setFrame:CGRectMake(100, 200, 100, 40)];
    [button setTitle:@"show asset" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton* editButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [editButton setFrame:CGRectMake(100, 300, 100, 40)];
    [editButton setTitle:@"edit mode" forState:UIControlStateNormal];
    [editButton addTarget:self action:@selector(editButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:editButton];
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 400, 100, 100)];
    [self.view addSubview:_imageView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClicked:(id)sender
{
    __block ELCAlbumPickerController* picker = [[ELCAlbumPickerController alloc] initWithCropImage:^(NSArray *cropImages) {
        
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
    }];
    picker.singleImage = NO;
    ELCImagePickerController* imagePicker = [[ELCImagePickerController alloc] initWithRootViewController:picker];
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

- (void)editButtonClicked:(id)sender
{
    __block ELCAlbumPickerController* picker = [[ELCAlbumPickerController alloc] initWithCropImage:^(NSArray *cropImages) {
        
        [picker.presentingViewController dismissViewControllerAnimated:YES completion:Nil];
        if ([cropImages count] > 0) {
            
            [_imageView setImage:cropImages[0]];
        }
    }];
    picker.singleImage = YES;
    picker.allowEdit = YES;
    ELCImagePickerController* imagePicker = [[ELCImagePickerController alloc] initWithRootViewController:picker];
    [self presentViewController:imagePicker animated:YES completion:^{
        
    }];
}

@end
