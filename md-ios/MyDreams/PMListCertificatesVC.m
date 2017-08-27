//
//  PMListCertificatesVC.m
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListCertificatesVC.h"
#import "PMListCertificatesLogic.h"
#import "PMCollectionCertificateCell.h"
#import "DreambookCollectionViewCells.h"
#import "PMNibManagement.h"
#import "PMLoadPageCollectionViewCell.h"
#import "PMListNewCertificatesVC.h"
#import "PMCollectionViewColumnLayout.h"

NSString *const kHeaderViewIdentifier = @"HeaderView";
NSString *const kListNewCertificatesVCIdentifier = @"listNewCertificatesVC";

@interface PMListCertificatesVC () <UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) PMListCertificatesLogic *logic;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@property (weak, nonatomic) PMListNewCertificatesVC *containerVC;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@end

@implementation PMListCertificatesVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    [self.collectionView registerCellNIBForClass:[PMLoadPageCollectionViewCell class]];
    self.collectionView.collectionViewLayout = [[PMCollectionViewColumnLayout alloc] init];
    ((PMCollectionViewColumnLayout *)self.collectionView.collectionViewLayout).columnCount = 2;
    
    PMListNewCertificatesVC *listCertificatesVC = [self.storyboard instantiateViewControllerWithIdentifier:kListNewCertificatesVCIdentifier];
    [self addChildViewController:listCertificatesVC];
    [listCertificatesVC didMoveToParentViewController:self];
    self.logic.containerLogic = listCertificatesVC.logic;
    self.containerVC = listCertificatesVC;
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    
    @weakify(self);
    [[RACSignal combineLatest:@[[RACObserve(self.logic.viewModel, certificates) ignore:nil],
                                [RACObserve(self.containerVC, isNewCertificatesEmpty) distinctUntilChanged]]]
        subscribeNext:^(id x) {
            @strongify(self)
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

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"dreambook.list_certificates.title", nil) uppercaseString];
}

#pragma mark - PMRefreshableController

- (UIScrollView *)refreshableScrollView
{
    return self.collectionView;
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if ((section == 0) && (!self.containerVC.isNewCertificatesEmpty)) {
        return CGSizeMake(self.view.bounds.size.width, 190.0f);
    }
    else {
        return CGSizeZero;
    }
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.logic.hasNextPage ? 2 : 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.logic.viewModel.certificates.count;
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PMCollectionCertificateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:self.cell.kPMReuseIdentifierCertificateCell forIndexPath:indexPath];
        cell.viewModel = self.logic.viewModel.certificates[indexPath.row];
        return cell;
    }
    else if(indexPath.section == 1) {
        PMLoadPageCollectionViewCell *cell = [collectionView dequeueReusableCellForClass:[PMLoadPageCollectionViewCell class] indexPath:indexPath];
        return cell;
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *reusableview = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        if (indexPath.section == 0) {
            UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kHeaderViewIdentifier forIndexPath:indexPath];
            reusableview = headerView;
            
            if (![self.containerVC.view isDescendantOfView:headerView]) {
                [headerView addSubview:self.containerVC.view];
                [self.containerVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(headerView);
                }];;
            }
        }
    }
    return reusableview;
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
	[self.logic selectCertificateWithIndex:indexPath.row];
}

@end
