//
//  AlbumPickerController.m
//
//  Created by ELC on 2/15/11.
//  Copyright 2011 ELC Technologies. All rights reserved.
//

#import "ELCAlbumPickerController.h"
#import "ELCImagePickerController.h"
#import "ELCAssetTablePicker.h"

@interface ELCAlbumPickerController ()

@property (nonatomic, strong) ALAssetsLibrary *library;
@property (nonatomic, strong) UITableView* albumTableView;
@property (nonatomic, copy) ELCCropImage cropBlock;
@end

@implementation ELCAlbumPickerController

@synthesize parent = _parent;
@synthesize assetGroups = _assetGroups;
@synthesize library = _library;

#pragma mark -
#pragma mark View lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        _allowEdit = NO;
        _singleImage = NO;
    }
    return self;
}

- (instancetype)initWithSingleImage:(BOOL)isSingle canEdit:(BOOL)edit cropImage:(ELCCropImage)cropImageBlock
{
    self = [super init];
    if (self) {
        
        _allowEdit = edit;
        _singleImage = isSingle;
        _cropBlock = cropImageBlock;
    }
    return self;
}

- (instancetype)initWithCropImage:(ELCCropImage)cropImageBlock;
{
    self = [super init];
    if (self) {
        
        _cropBlock = cropImageBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (IsIOS7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    _albumTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [_albumTableView setDelegate:self];
    [_albumTableView setDataSource:self];
    [self.view addSubview:_albumTableView];

    [self initialNavigationItem];

    NSMutableArray *tempArray = [[NSMutableArray alloc] init];
	self.assetGroups = tempArray;
    
    
    ALAssetsLibrary *assetLibrary = [[ALAssetsLibrary alloc] init];
    self.library = assetLibrary;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(libraryChanged:) name:ALAssetsLibraryChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(assetChanged:) name:ALAssetLibraryUpdatedAssetsKey object:nil];
    
    [self loadAlbumData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelImagePicker) name:@"elcpickerdissmiss" object:nil];
}

- (void)initialNavigationItem
{
    UIButton* btnAddChat = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnAddChat setTitle:@"取消" forState:UIControlStateNormal];
    [btnAddChat setFrame:CGRectMake(0, 0, 36, 36)];
    [btnAddChat setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btnAddChat addTarget:self action:@selector(cancelImagePicker) forControlEvents:UIControlEventTouchUpInside];
    if(IsIOS7)
        btnAddChat.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -20);
    UIBarButtonItem *barBtnAddChar = [[UIBarButtonItem alloc] initWithCustomView:btnAddChat];
    [self.navigationItem setRightBarButtonItem:barBtnAddChar];
}

- (void)loadAlbumData
{
    // Load Albums into assetGroups
    
    [self.assetGroups removeAllObjects];
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       @autoreleasepool {
                           // Group enumerator Block
                           void (^assetGroupEnumerator)(ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop)
                           {
                               if (group == nil) {
                                   return;
                               }
                               
                               // added fix for camera albums order
                               NSString *sGroupPropertyName = (NSString *)[group valueForProperty:ALAssetsGroupPropertyName];
                               NSUInteger nType = [[group valueForProperty:ALAssetsGroupPropertyType] intValue];
                               
                               if ([[sGroupPropertyName lowercaseString] isEqualToString:@"camera roll"] && nType == ALAssetsGroupSavedPhotos) {
                                   [self.assetGroups insertObject:group atIndex:0];
                               }
                               else {
                                   [self.assetGroups addObject:group];
                               }
                               
                               // Reload albums
                               [self performSelectorOnMainThread:@selector(reloadTableView) withObject:nil waitUntilDone:YES];
                           };
                           
                           // Group Enumerator Failure Block
                           void (^assetGroupEnumberatorFailure)(NSError *) = ^(NSError *error) {
                               
                               UIAlertView * alert = [[UIAlertView alloc] initWithTitle:@"Error" message:[NSString stringWithFormat:@"Album Error: %@ - %@", [error localizedDescription], [error localizedRecoverySuggestion]] delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
                               [alert show];
                               
                               NSLog(@"A problem occured %@", [error description]);
                           };
                           
                           // Enumerate Albums
                           [self.library enumerateGroupsWithTypes:ALAssetsGroupAll
                                                       usingBlock:assetGroupEnumerator 
                                                     failureBlock:assetGroupEnumberatorFailure];
                       }
                   });
}

- (void)reloadTableView
{
	[self.albumTableView reloadData];
	[self.navigationItem setTitle:@"Select an Album"];
}

- (void)selectedAssets:(NSArray*)assets
{
	[_parent selectedAssets:assets];
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.assetGroups count];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Get count
    ALAssetsGroup *g = (ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row];
    [g setAssetsFilter:[ALAssetsFilter allPhotos]];
    NSInteger gCount = [g numberOfAssets];
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ (%ld)",[g valueForProperty:ALAssetsGroupPropertyName], (long)gCount];
    [cell.imageView setImage:[UIImage imageWithCGImage:[(ALAssetsGroup*)[self.assetGroups objectAtIndex:indexPath.row] posterImage]]];
	[cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    
    UIView *selectImageView = [[UIView alloc] initWithFrame:cell.bounds];
    cell.selectedBackgroundView = selectImageView;
    if (IsIOS6) {
        NSInteger rowHeight = 0;
        if (SCREEN_HEIGHT >= 736.0) {
            rowHeight = 80;
        }else if (SCREEN_HEIGHT >= 667.0) {
            rowHeight = 70;
        }else {
            rowHeight = 60;
        }
    } else {

    }
	
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ELCAssetPicker* picker = [[ELCAssetPicker alloc] init];
    picker.assetGroup = [self.assetGroups objectAtIndex:indexPath.row];
    [picker.assetGroup setAssetsFilter:[ALAssetsFilter allPhotos]];
    picker.singleSelection = _singleImage;
    picker.allowEdit = _allowEdit;
    picker.cropBlock = _cropBlock;
	[self.navigationController pushViewController:picker animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
    if (SCREEN_HEIGHT >= 736.0) {
        
        return 80;
    }else if (SCREEN_HEIGHT >= 667.0) {
        
        return 70;
    }else {
        
        return 60;
    }
}

- (void)cancelImagePicker
{
    if (_cropBlock) {
        _cropBlock(nil);
    }
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)dealloc 
{	

}

#pragma mark - notification

- (void)libraryChanged:(NSNotification*)note
{
    __weak ELCAlbumPickerController* weakSelf = self;
    NSLog(@"libraryChanged:%@", note.userInfo);
    NSSet* AssetsKey = note.userInfo[@"ALAssetLibraryUpdatedAssetsKey"];
    NSLog(@"url:%@", AssetsKey);
    if (AssetsKey) {
        
        [AssetsKey enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
           
            NSURL* urlStr = obj;
            [weakSelf.library assetForURL:urlStr resultBlock:^(ALAsset *asset) {
                
                NSLog(@"date:%@", [asset valueForProperty:ALAssetPropertyDate]);
            } failureBlock:^(NSError *error) {
                
            }];
        }];
        
    }
    [weakSelf loadAlbumData];
//    NSString* assetUrl;
//    [self.library assetForURL:<#(NSURL *)#> resultBlock:<#^(ALAsset *asset)resultBlock#> failureBlock:<#^(NSError *error)failureBlock#>]
}

- (void)assetChanged:(NSNotification*)note
{
    NSLog(@"assetChanged:%@", note.userInfo);
}

@end

