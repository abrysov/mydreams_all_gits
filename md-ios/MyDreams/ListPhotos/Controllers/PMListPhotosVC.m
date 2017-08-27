//
//  PMListPhotosVC.m
//  myDreams
//
//  Created by Ivan Ushakov on 12/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListPhotosVC.h"
#import "PMListPhotosLogic.h"
#import "PMPhotoCollectionViewCell.h"
#import "PMLoadPageCollectionViewCell.h"
#import "PMListPhotosViewModel.h"
#import "PMNibManagement.h"
#import "PhotosCollectionViewCells.h"
#import "PMImageSelector.h"
#import "PMFullscreenLoadingView.h"
#import "MyDreams-Swift.h"
#import "ObjectiveSugar.h"
#import "PMPhotoViewModel.h"

@interface PMListPhotosVC () <UICollectionViewDataSource, UICollectionViewDelegate, PMImageSelectorDelegate, SKPhotoBrowserDelegate>
@property (strong, nonatomic) PMListPhotosLogic *logic;

@property (strong, nonatomic) PMImageSelector *imageSelector;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@end

@implementation PMListPhotosVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    [self.collectionView registerCellNIBForClass:[PMLoadPageCollectionViewCell class]];
    
    self.imageSelector = [[PMImageSelector alloc] initWithController:self needCrop:NO resizeTo:CGSizeMake(1920.0f, 1080.0f)];
    self.imageSelector.delegate = self;
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = NSLocalizedString(@"photos.list.title", nil);
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    [RACObserve(self.logic, viewModel.photos) subscribeNext:^(NSArray *photos) {
        @strongify(self);
        [self.collectionView reloadData];
    }];
    
    [RACObserve(self.logic, viewModel.isMe) subscribeNext:^(NSNumber *isMe) {
        if ([isMe boolValue]) {
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"add_icon"]
                                                                                      style:UIBarButtonItemStylePlain
                                                                                     target:self
                                                                                     action:@selector(addPhotoButtonHandler:)];
        }
        else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }];
    
    id hideLoadingViewBlock = ^(id x) {
        @strongify(self);
        [self.loadingView hide];
    };
    
    [self.logic.uploadPhotoCommand.errors subscribeNext:hideLoadingViewBlock];
    [self.logic.deletePhotoAtIndexCommand.errors subscribeNext:hideLoadingViewBlock];
    [[self.logic.uploadPhotoCommand.executionSignals switchToLatest] subscribeNext:hideLoadingViewBlock];
    [[self.logic.deletePhotoAtIndexCommand.executionSignals switchToLatest] subscribeNext:hideLoadingViewBlock];
    
    [[RACObserve(self.logic, viewModel.progress)
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSNumber *value) {
            @strongify(self);
			[self.loadingView setProgress:[value floatValue] animated:YES];
        }];
    
    
    [[RACSignal combineLatest:@[self.logic.loadNextPage.enabled, RACObserve(self, showingLoadNextPageCell)]]
        subscribeNext:^(RACTuple *x) {
            NSNumber *enabled = x.first;
            NSNumber *showingLoadNextPageCell = x.second;
         
            @strongify(self);
            if ([enabled boolValue] && [showingLoadNextPageCell boolValue]) {
                [self.logic.loadNextPage execute:self];
            }
     }];
}

#pragma mark - PMRefreshableController

- (UIScrollView *)refreshableScrollView
{
    return self.collectionView;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.logic.hasNextPage ? 2 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.logic.viewModel.photos.count;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PMPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cell.kPMReuseIdentifierListPhotosCell forIndexPath:indexPath];
        cell.viewModel = self.logic.viewModel.photos[indexPath.row];
        return cell;
    }
    else if(indexPath.section == 1) {
        PMLoadPageCollectionViewCell *cell = [collectionView dequeueReusableCellForClass:[PMLoadPageCollectionViewCell class] indexPath:indexPath];
        return cell;
    }
    
    return nil;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        PMLoadPageCollectionViewCell *loadPageCollectionViewCell = (PMLoadPageCollectionViewCell *)cell;
        [loadPageCollectionViewCell.activity startAnimating];
        self.showingLoadNextPageCell = YES;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        PMLoadPageCollectionViewCell *loadPageCollectionViewCell = (PMLoadPageCollectionViewCell *)cell;
        [loadPageCollectionViewCell.activity stopAnimating];
        self.showingLoadNextPageCell = NO;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PMPhotoCollectionViewCell *selectedCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
        NSArray *photos = [self.logic.viewModel.photos map:^id(id<PMPhotoViewModel> photo) {
            return [SKPhoto photoWithImageURL:photo.url.absoluteString];
        }];
        PMPhotoBrowser *photoBrowser = [[PMPhotoBrowser alloc] initWithOriginImage:selectedCell.photoImageView.image
                                                                 photos:photos
                                                       animatedFromView:selectedCell.photoImageView];
        photoBrowser.delegate = self;
        [photoBrowser initializePageIndex:indexPath.item];
        photoBrowser.displayAction = NO;
        photoBrowser.bounceAnimation = YES;
        photoBrowser.displayDeleteButton = self.logic.viewModel.isMe;
        photoBrowser.displayToolbar = NO;
        [self presentViewController:photoBrowser animated:YES completion:nil];
    }
}

#pragma mark - SKPhotoBrowserDelegate

- (void)removePhoto:(SKPhotoBrowser * _Nonnull)browser index:(NSInteger)index reload:(void (^ _Nonnull)(void))reload
{
    [self.logic.deletePhotoAtIndexCommand execute:@(index)];
    [self.loadingView show];
    reload();
}

#pragma mark - image selector delegate

- (void)imageSelector:(PMImageSelector *)imageSelector didSelectImage:(UIImage *)image
{
    [self.logic.uploadPhotoCommand execute:image];
    [self.loadingView show];
}

#pragma mark - actions

- (IBAction)addPhotoButtonHandler:(id)sender
{
    [self.imageSelector show];
}

- (IBAction)prepareForUnwindListPhotos:(UIStoryboardSegue *)segue {}

@end
