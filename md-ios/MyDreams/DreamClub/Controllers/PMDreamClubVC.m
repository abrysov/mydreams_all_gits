//
//  PMDreamClubPMDreamClubVC.m
//  myDreams
//
//  Created by AlbertA on 08/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamClubVC.h"
#import "PMDreamClubLogic.h"
#import "PMLoadPageTableViewCell.h"
#import "PMNibManagement.h"
#import "PMPostTableViewCell.h"
#import "PMDreamClubViewModel.h"
#import "PMDreamclubSegues.h"
#import "PMDreamClubHeaderVC.h"
#import "PMFastLinksContainerController.h"

@interface PMDreamClubVC () <PMDreamClubHeaderDelegate>
@property (strong, nonatomic) PMDreamClubLogic *logic;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@end

@implementation PMDreamClubVC
@dynamic logic;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([[segue identifier] isEqualToString:kPMSegueIdentifierToDreamClubHeaderVC]) {
        PMDreamClubHeaderVC *dreamclubHeaderVC = [segue destinationViewController];
        self.logic.containerLogic = dreamclubHeaderVC.logic;
        dreamclubHeaderVC.delegate = self;
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fastLinksContainer.underTabBar = YES;
    self.fastLinksContainer.style = PMFastLinksContainerControllerStyleDark;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.fastLinksContainer.underTabBar = NO;
    self.fastLinksContainer.style = PMFastLinksContainerControllerStyleLight;
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    @weakify(self);
    [RACObserve(self.logic.viewModel, items) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
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
    
    [[RACObserve(self.logic, viewModel) ignore:nil]
        subscribeNext:^(id input) {
            @strongify(self);
            [self.tableView setContentOffset:CGPointZero animated:NO];
        }];
}

- (void)setupUI
{
    [super setupUI];
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
    [self.tableView registerCellNIBForClass:[PMPostTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMLoadPageTableViewCell class]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = [PMPostTableViewCell estimatedRowHeight];
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"dreamclub.dreamclub.title", nil) uppercaseString];
}

- (UIView *)viewForStatesViewsConstraints
{
    return self.tableView;
}

#pragma mark - PMContainedListPhotosVCDelegate

- (void)dreamclubHeaderVC:(PMDreamClubHeaderVC *)dreamclubHeaderVC photosLoaded:(BOOL)photosLoaded
{
    if (photosLoaded) {
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 474.0f);
    }
    else {
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 408.0f);
    }
}

#pragma mark - PMRefreshableController

- (UIScrollView *)refreshableScrollView
{
    return self.tableView;
}

#pragma mark - UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.logic.hasNextPage ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.logic.viewModel.items.count;
    } else if (section == 1) {
        return 1;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PMPostTableViewCell *cell = [tableView dequeueReusableCellForClass:[PMPostTableViewCell class] indexPath:indexPath];
        cell.toFullPostCommand = self.logic.toFullPostCommand;
        cell.viewModel = self.logic.viewModel.items[indexPath.row];
        return cell;
    }
    else if(indexPath.section == 1) {
        return [tableView dequeueReusableCellForClass:[PMLoadPageTableViewCell class] indexPath:indexPath];
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        PMLoadPageTableViewCell *loadPageTableViewCell = (PMLoadPageTableViewCell*)cell;
        [loadPageTableViewCell.activity startAnimating];
        self.showingLoadNextPageCell = YES;
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1) {
        PMLoadPageTableViewCell *loadPageTableViewCell = (PMLoadPageTableViewCell*)cell;
        [loadPageTableViewCell.activity stopAnimating];
        self.showingLoadNextPageCell = NO;
    }
}

#pragma mark - private

-(IBAction)prepareForUnwindDreamClub:(UIStoryboardSegue *)segue {}

@end
