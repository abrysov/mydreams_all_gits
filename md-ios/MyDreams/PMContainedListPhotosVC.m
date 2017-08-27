//
//  PMListPhotosVC.m
//  MyDreams
//
//  Created by user on 06.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMContainedListPhotosVC.h"
#import "PMContainedListPhotosLogic.h"
#import "PMCollectionPhotoCell.h"
#import "PMLoadPageCollectionViewCell.h"
#import "PMNibManagement.h"
#import "DreambookCollectionViewCells.h"
#import "ObjectiveSugar.h"
#import "MyDreams-Swift.h"

@interface PMContainedListPhotosVC () <SKPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@end

@implementation PMContainedListPhotosVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    [self.collectionView registerCellNIBForClass:[PMLoadPageCollectionViewCell class]];
    self.collectionView.scrollsToTop = NO;
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    [RACObserve(self.logic, viewModel.photos) subscribeNext:^(NSArray *photos) {
        @strongify(self);
        
        if (photos.count == 0) {
            [self.delegate containedListPhotoVC:self photosLoaded:NO];
        }
        else {
            [self.delegate containedListPhotoVC:self photosLoaded:YES];
        }
        
        [self.collectionView reloadData];
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
        PMCollectionPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cell.kPMReuseIdentifierPhotoCell forIndexPath:indexPath];
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
        PMCollectionPhotoCell *selectedCell = (id)[collectionView cellForItemAtIndexPath:indexPath];
        NSArray *photos = [self.logic.viewModel.photos map:^id(id<PMPhotoViewModel> viewModel) {
            return [SKPhoto photoWithImageURL:viewModel.url.absoluteString];
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
    reload();
}

@end
