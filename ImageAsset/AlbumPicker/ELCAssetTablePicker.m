//
//  AssetTablePicker.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAssetTablePicker.h"
#import "ELCAssetCell.h"
#import "ELCAsset.h"
#import "ELCAlbumPickerController.h"

#define BOTTOM_HEIGHT 45.0f

@interface ELCAssetTablePicker ()

@property (nonatomic, assign) int columns;
@property (nonatomic, strong) NSMutableArray* selectedIndexArray;
@property (nonatomic, strong) UIView* bottomView;
@end

@implementation ELCAssetTablePicker

@synthesize parent = _parent;;
//@synthesize selectedAssetsLabel = _selectedAssetsLabel;
//@synthesize assetGroup = _assetGroup;
@synthesize elcAssets = _elcAssets;
@synthesize singleSelection = _singleSelection;
@synthesize columns = _columns;

#pragma mark - synthesize

- (void)setAssetGroup:(ALAssetsGroup*)assetGroup
{
    if (_assetGroup != assetGroup) {
        _assetGroup = nil;
        _assetGroup = assetGroup;
        _navigationTitle = [_assetGroup valueForProperty:ALAssetsGroupPropertyName];
    }
}

- (ALAssetsGroup*)assetGroup
{
    return _assetGroup;
}

#pragma mark - life circle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor whiteColor]];
//    [self.navigationItem setHidesBackButton:YES];
    
    if (IsIOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self initialNavigationItem];
    self.navigationBarTitle.text = _navigationTitle;
    
    _assetTableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - BOTTOM_HEIGHT) style:UITableViewStylePlain];
    
    if (_singleSelection) {
        
        [_assetTableview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    }else {
        [self initialBottomItems];
    }
    
    [_assetTableview setDelegate:self];
    [_assetTableview setDataSource:self];
    [_assetTableview setSeparatorStyle:UITableViewCellSeparatorStyleNone];
	[_assetTableview setAllowsSelection:NO];
    [self.view addSubview:_assetTableview];
    
    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
    self.elcAssets = tempArray;

    _selectedAssects = [[NSMutableArray alloc] init];
    _selectedIndexArray = [[NSMutableArray alloc] init];
	_preCount = 0;
    

//    if (self.immediateReturn) {
//        
//    } else {
//        UIButton * customButton=[UIButton buttonWithType:UIButtonTypeCustom];
//        customButton.frame=CGRectMake(0, 0, 80, 40);
//        customButton.backgroundColor=[UIColor clearColor];
//        customButton.tintColor=[UIColor clearColor];
//        //[customButton.titleLabel setFont:[UIFont systemFontOfSize:11]];
//        
//        [customButton setTitle:QLocalString(@"1111", @"完成") forState:UIControlStateNormal];
//        [customButton addTarget:self action:@selector(doneAction:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem * doneButtonItem=[[UIBarButtonItem alloc] initWithCustomView:customButton];
//        
//        [self.navigationItem setRightBarButtonItem:doneButtonItem];
//    }
	[self performSelectorInBackground:@selector(preparePhotos) withObject:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    if (IsIOS6) {
//        [_assetTableview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - BOTTOM_HEIGHT)];
//        [_bottomView setFrame:CGRectMake(0, self.view.frame.size.height - BOTTOM_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT)];
//    }
    if (_singleSelection) {
        
        [_assetTableview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height)];
    }else {
        [_assetTableview setFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height - BOTTOM_HEIGHT)];
        [_bottomView setFrame:CGRectMake(0, self.view.frame.size.height - BOTTOM_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT)];
    }

    self.columns = 4;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return NO;
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    self.columns = self.view.bounds.size.width / 80;
    [_assetTableview reloadData];
}

//- (void)initialNavigationItem
//{
//    UIButton *btnBack=[[UIButton alloc] initWithFrame:CGRectMake(0, 0, 36, 36)];
//    [btnBack setImage:[ResourceHelper loadImageByThemeOriginalSize:@"back"] forState:UIControlStateNormal];
////    [btnBack setImage:[ResourceHelper loadImageByThemeOriginalSize:@"back_press"] forState:UIControlStateHighlighted];
//    [btnBack addTarget:self action:@selector(btnBackClick:) forControlEvents:UIControlEventTouchUpInside];
//    if(IsIOS7)
//        btnBack.contentEdgeInsets = UIEdgeInsetsMake(0, -20, 0, 0);
//    UIBarButtonItem *BackBarBtn = [[UIBarButtonItem alloc] initWithCustomView:btnBack];
//    self.navigationItem.leftBarButtonItem=BackBarBtn;
//    
//    _navigationBarTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0 , 100, 44)];
//    _navigationBarTitle.backgroundColor = [UIColor clearColor];  //设置Label背景透明
//    _navigationBarTitle.font = NAVIGATION_TITLE_FONT;  //设置文本字体与大小
//    _navigationBarTitle.textAlignment = NSTextAlignmentCenter;
//    self.navigationItem.titleView = _navigationBarTitle;
//    _navigationBarTitle.textColor = [UIColor whiteColor];;
//    _navigationBarTitle.text = _navigationTitle;
//}

- (void)initialBottomItems
{
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - BOTTOM_HEIGHT, SCREEN_WIDTH, BOTTOM_HEIGHT)];
    [_bottomView setBackgroundColor:[UIColor whiteColor]];
    
    UIButton* preViewButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [preViewButton setFrame:CGRectMake(10, 7, 70, 31)];
    [preViewButton setTag:10];
    [preViewButton setTitle:@"预览" forState:UIControlStateNormal];
    [preViewButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [preViewButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [preViewButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [preViewButton.layer setBorderWidth:1.0f];
    [preViewButton.layer setCornerRadius:3.0f];
    [preViewButton.layer setMasksToBounds:YES];
    [preViewButton addTarget:self action:@selector(preViewButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [preViewButton setEnabled:NO];
    [_bottomView addSubview:preViewButton];
    
    UIButton* sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendButton setFrame:CGRectMake(SCREEN_WIDTH - 110, 7, 100, 31)];
    [sendButton setTag:11];
    [sendButton setTitle:@"发送" forState:UIControlStateDisabled];
    [sendButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor grayColor] forState:UIControlStateDisabled];
    [sendButton.layer setBorderColor:[UIColor grayColor].CGColor];
    [sendButton.layer setBorderWidth:1.0f];
    [sendButton.layer setCornerRadius:3.0f];
    [sendButton.layer setMasksToBounds:YES];
    [sendButton addTarget:self action:@selector(sendButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [sendButton setEnabled:NO];
    [_bottomView addSubview:sendButton];
    
    [self.view addSubview:_bottomView];
}

- (void)preparePhotos
{
    __weak ELCAssetTablePicker* weakself = self;
    @autoreleasepool {
        NSLog(@"enumerating photos");
        [self.assetGroup enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            
            if(result == nil) {
                return;
            }
            
            ELCAsset *elcAsset = [[ELCAsset alloc] initWithAsset:result];
            [elcAsset setParent:self];
            [weakself.elcAssets addObject:elcAsset];
//            [elcAsset release];
        }];
        NSLog(@"done enumerating photos");
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            [weakself.assetTableview reloadData];
        });

    }
}

#pragma mark UITableViewDataSource Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return ceil([self.elcAssets count] / (float)self.columns);
}

- (NSArray *)assetsForIndexPath:(NSIndexPath *)path
{
    NSInteger index = path.row * self.columns;
    NSInteger length = MIN(self.columns, [self.elcAssets count] - index);
    return [self.elcAssets subarrayWithRange:NSMakeRange(index, length)];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{    
    static NSString *CellIdentifier = @"Cell";
        
    ELCAssetCell *cell = (ELCAssetCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        cell = [[ELCAssetCell alloc] initWithAssets:[self assetsForIndexPath:indexPath] reuseIdentifier:CellIdentifier];
        if (_singleSelection) {
            cell.showSelected = NO;
        }else {
            cell.showSelected = YES;
        }

    } else {		
		[cell setAssets:[self assetsForIndexPath:indexPath]];
	}
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (SCREEN_HEIGHT >= 736.0) {
        
        return 105;
    }else if (SCREEN_HEIGHT >= 667.0) {
        
        return 95;
    }else {
        
        return 85;
    }
	
}

- (void)totalSelectedAssets {
    
    NSLog(@"totalSelectedAssets");
    if (_singleSelection) {
        
    }else {
        int count = 0;
        
        for(ELCAsset *asset in self.elcAssets) {
            if([asset selected]) {
                count++;
            }
        }
        _preCount = count;
        [self refreshSendButton:count];
    }
//    return count;
}

- (NSMutableArray*)prepareSelectedAsset
{
    __block NSMutableArray* array = [NSMutableArray array];
    [self.elcAssets enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        ELCAsset *asset = obj;
        if (asset.selected) {
            [array addObject:asset];
            [_selectedIndexArray addObject:@(idx)];
        }
    }];
    return array;
}

- (void)doneAction:(id)sender
{
    NSLog(@"doneAction");
	NSMutableArray *selectedAssetsImages = [[NSMutableArray alloc] init];
    
	for(ELCAsset *elcAsset in self.elcAssets) {
        
		if([elcAsset selected]) {
			
			[selectedAssetsImages addObject:[elcAsset asset]];
		}
	}
    
    [self.parent selectedAssets:selectedAssetsImages];
}

#pragma mark - touch event

- (void)assetSelected:(id)asset
{
    if (_singleSelection) {
        
        if (_allowEdit) {
            
            ELCAsset* selectedAsset = asset;
            ELCImageEditorController* editor = [[ELCImageEditorController alloc] initWithImageID:selectedAsset allowEdit:YES cropSzie:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
            if (_cropBlock) {
                editor.cropBlock = _cropBlock;
            }
            self.navigationController.navigationBarHidden = YES;
            [self.navigationController pushViewController:editor animated:YES];
        }else {
            ELCAsset* selectedAsset = asset;
            ALAsset* imageAsset = [selectedAsset asset];
            ALAssetRepresentation* representation = [imageAsset defaultRepresentation];
            UIImage* image = [UIImage imageWithCGImage:[representation fullScreenImage]];
            _cropBlock(image);
        }
    }
//    ELCAsset * myAsset=asset;
//    NSInteger selectedCount = 0;
//    for(ELCAsset *elcAsset in self.elcAssets) {
//        
//        if(asset != elcAsset) {
//            elcAsset.selected = NO;
//        }
//        if (elcAsset.selected) {
//            selectedCount ++;
//        }
//    }
//    if (myAsset.selected) {
//        if (self.singleSelection) {
//            
//            for(ELCAsset *elcAsset in self.elcAssets) {
//                
//                if(asset != elcAsset) {
//                    elcAsset.selected = NO;
//                }
//                if (elcAsset.selected) {
//                    selectedCount ++;
//                }
//            }
//        }
//        if (self.immediateReturn) {
//            NSArray *singleAssetArray = [NSArray arrayWithObject:[asset asset]];
//            [(NSObject *)self.parent performSelector:@selector(selectedAssets:) withObject:singleAssetArray afterDelay:0];
//        }
//    }
//    [self refreshSendButton:selectedCount];
    NSLog(@"assetSelected");
}

- (void)showAlert
{
//    [self ShowNoticeMessage:@"最多只能选择8张图片"];
    UIAlertView* alView = [[UIAlertView alloc] initWithTitle:@"最多只能选择8张图片" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alView show];
}

- (void)refreshSendButton:(NSInteger)selectedCount
{
    UIButton *previewButton = (UIButton*)[self.view viewWithTag:10];
    UIButton *sendButton = (UIButton*)[self.view viewWithTag:11];
    if (selectedCount == 0) {
        [previewButton setEnabled:NO];
        [previewButton.layer setBorderColor:[UIColor grayColor].CGColor];
        [sendButton setEnabled:NO];
        [sendButton.layer setBorderColor:[UIColor grayColor].CGColor];
    }else {
        [previewButton setEnabled:YES];
        [previewButton.layer setBorderColor:[UIColor blueColor].CGColor];
        [sendButton setEnabled:YES];
        [sendButton.layer setBorderColor:[UIColor blueColor].CGColor];
        [sendButton setTitle:[NSString stringWithFormat:@"发送(%ld)", (long)selectedCount] forState:UIControlStateNormal];
    }
}

#pragma mark - button click event

- (void)preViewButtonClicked:(id)sender
{
    NSMutableArray* array = [self prepareSelectedAsset];
    
    __weak ELCAssetTablePicker* weakself = self;
    ELCPreviewController* controller = [[ELCPreviewController alloc] initWithImageAsset:array update:^(NSArray *asset) {
        
        [_selectedIndexArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            NSInteger index = [(NSNumber*)obj integerValue];
            ELCAsset* assetPre = weakself.elcAssets[index];
            ELCAsset* assetModify = asset[idx];
            assetPre.selected = assetModify.selected;
        }];
        [_selectedIndexArray removeAllObjects];
        [_assetTableview reloadData];
        [self totalSelectedAssets];
    }];
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)sendButtonClicked:(id)sender
{
    //todo:
    NSMutableArray* array = [self prepareSelectedAsset];
//    [self.navigationController performSelector:@selector(selectedAssets:) withObject:array];
    [(ELCImagePickerController*)self.navigationController selectedAssets:array];
}

- (void)btnBackClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - dealloc

- (void)dealloc 
{
//    [_assetGroup release];    
//    [_elcAssets release];
//    [_selectedAssetsLabel release];
//    [super dealloc];    
}

@end
