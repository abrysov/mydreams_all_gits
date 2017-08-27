//
//  PMListNewCertificatesVC.m
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListNewCertificatesVC.h"
#import "PMCertificatePageVC.h"
#import "PMPage.h"

NSString * const kSegueIdentifierToCertificatesPVC = @"ToCertificatesPVC";
NSString * const kCertificatePageVCIdentifier = @"certificatePageVC";

@interface PMListNewCertificatesVC () <UIPageViewControllerDataSource>
@property (nonatomic, weak) UIPageViewController *pageViewController;
@property (nonatomic, assign) BOOL showingLoadNextPageCell;
@end

@implementation PMListNewCertificatesVC
@dynamic logic;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([[segue identifier] isEqualToString:kSegueIdentifierToCertificatesPVC]) {
        UIPageViewController *certificatesPVC = [segue destinationViewController];
        certificatesPVC.dataSource = self;
        self.pageViewController = certificatesPVC;
    }
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    @weakify(self);
    
    RACSignal *certificatesObserveSignal = [RACObserve(self.logic.viewModel, certificates) ignore:nil];
    
    
    [[[[certificatesObserveSignal
        filter:^BOOL(NSArray *value) {
            return (value.count > 0);
        }]
        map:^id(id value) {
            return @YES;
        }]
        distinctUntilChanged]
        subscribeNext:^(id value) {
            @strongify(self);
            PMCertificatePageVC *startingViewController = [self viewControllerAtIndex:0];
            NSArray *viewControllers = @[startingViewController];
            [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
        }];

    [certificatesObserveSignal subscribeNext:^(NSArray *certificates) {
        @strongify(self);
        self.isNewCertificatesEmpty = (certificates.count == 0);
    }];
    
    [[RACSignal combineLatest:@[self.logic.loadNextPage.enabled, RACObserve(self, showingLoadNextPageCell)]]
        subscribeNext:^(RACTuple *x) {
            NSNumber *enabled = x.first;
            NSNumber *showingLoadNextPageCell = x.second;
         
            @strongify(self);
            if ([enabled boolValue] && [showingLoadNextPageCell boolValue]) {
                [self.logic.loadNextPage execute:self];
                self.showingLoadNextPageCell = NO;
            }
        }];
  
    [[RACObserve(self.logic, currentPage) filter:^BOOL(PMPage *page) {
        @strongify(self);
        return ([page.page intValue] == 1) && (self.pageViewController.viewControllers.count > 0);
    }] subscribeNext:^(id value) {
        @strongify(self);
        PMCertificatePageVC *startingViewController = [self viewControllerAtIndex:0];
        NSArray *viewControllers = @[startingViewController];
        [self.pageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    }];
}

#pragma mark - UIPageViewControllerDataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PMCertificatePageVC *) viewController).pageIndex;
    
    if ((index == 0) || (index == NSNotFound)) {
        return nil;
    }
    
    return [self viewControllerAtIndex:index - 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    NSUInteger index = ((PMCertificatePageVC *) viewController).pageIndex;

    if ((index == NSNotFound) || ((index + 1) == self.logic.viewModel.certificates.count)) {
        return nil;
    }
    
    if ((index + 3) == self.logic.viewModel.certificates.count) {
        self.showingLoadNextPageCell = YES;
    }
    
    return [self viewControllerAtIndex:index + 1];
}

#pragma mark - private

- (PMCertificatePageVC *)viewControllerAtIndex:(NSUInteger)index
{
    if ((self.logic.viewModel.certificates.count == 0) || (index >= self.logic.viewModel.certificates.count)) {
        return nil;
    }
    PMCertificatePageVC *certificatePageVC = [self.storyboard instantiateViewControllerWithIdentifier:kCertificatePageVCIdentifier];
    certificatePageVC.viewModel = self.logic.viewModel.certificates[index];
    certificatePageVC.pageIndex = index;
    return certificatePageVC;
}

@end
