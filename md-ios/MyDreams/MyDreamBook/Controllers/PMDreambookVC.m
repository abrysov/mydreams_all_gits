//
//  PMMyDreamBookVC.m
//  myDreams
//
//  Created by Ivan Ushakov on 17/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookVC.h"
#import "PMDreambookLogic.h"
#import "PMHeaderDreambookView.h"
#import "PMImageSelector.h"
#import "PMImageForm.h"
#import "PMContainedListPhotosVC.h"
#import "UITextField+PM.h"
#import "UIColor+MyDreams.h"
#import "PMLoadPageTableViewCell.h"
#import "PMPostTableViewCell.h"
#import "PMNibManagement.h"
#import <RESideMenu/RESideMenu.h>
#import "PMFastLinksContainerController.h"
#import "PMDreambookHeaderViewModel.h"
#import "DreambookSegues.h"

NSString * const kPMDreambookVCContainedListPhotosVCIdentificator = @"ContainedListPhotosVC";

@interface PMDreambookVC () <PMImageSelectorDelegate, PMDreambookChangeImagesDelegate, PMContainedListPhotosVCDelegate>
@property (strong, nonatomic) PMDreambookLogic *logic;
@property (weak, nonatomic) IBOutlet PMHeaderDreambookView *dreambookHeaderView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *dreamerStateLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dreamerStateImageView;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toMoreButtonItem;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *toGiftButtonItem;
@property (assign, nonatomic) BOOL showingLoadNextPageCell;
@property (strong, nonatomic) PMImageSelector *imageSelector;
@property (assign, nonatomic) PMImageSelectorType imageSelectorType;
@property (strong, nonatomic) UIColor *navigationBarColor;
@property (strong, nonatomic) UIColor *previousNavigationBarColor;
@end

@implementation PMDreambookVC
@dynamic logic;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    self.navigationController.navigationBar.barTintColor = ([segue.identifier isEqualToString:kPMSegueIdentifierCloseDreambookVC]) ? self.previousNavigationBarColor : [UIColor dreambookNormalColor];
}

- (void)setupUI
{
    [super setupUI];
    self.previousNavigationBarColor = self.navigationController.navigationBar.barTintColor;
    PMContainedListPhotosVC *containedListPhotosVC = [self.storyboard instantiateViewControllerWithIdentifier:kPMDreambookVCContainedListPhotosVCIdentificator];
    containedListPhotosVC.delegate = self;
    [self addChildViewController:containedListPhotosVC];
    [containedListPhotosVC didMoveToParentViewController:self];
    self.logic.containerLogic = containedListPhotosVC.logic;
    [self.dreambookHeaderView.photosView addSubview:containedListPhotosVC.view];
    
    @weakify(self);
    [containedListPhotosVC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.dreambookHeaderView.photosView);
    }];
    
    self.tableView.tableHeaderView = self.dreambookHeaderView;
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc]init] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.tableView registerCellNIBForClass:[PMPostTableViewCell class]];
    [self.tableView registerCellNIBForClass:[PMLoadPageTableViewCell class]];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = [PMPostTableViewCell estimatedRowHeight];
    
    self.imageSelector = [[PMImageSelector alloc] initWithController:self needCrop:YES resizeTo:CGSizeMake(1920.0f, 1080.0f)];
    self.imageSelector.delegate = self;
    
    self.dreambookHeaderView.delegate = self;
    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 55, 0);
    self.tableView.scrollIndicatorInsets = self.tableView.contentInset;
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    
    if (self.navigationController.viewControllers.count == 1) {
        UIBarButtonItem *menuButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage imageNamed:@"menu_icon"]
                                       style:UIBarButtonItemStyleDone
                                       target:nil
                                       action:@selector(presentLeftMenuViewController:)];
        menuButton.tintColor = [UIColor whiteColor];
        self.navigationItem.leftBarButtonItem = menuButton;
    }
    else {
        UIBarButtonItem *backButton = [[UIBarButtonItem alloc]
                                       initWithImage:[UIImage imageNamed:@"back_icon"]
                                       style:UIBarButtonItemStyleDone
                                       target:nil
                                       action:nil];
        backButton.tintColor = [UIColor whiteColor];
        backButton.rac_command = self.logic.backCommand;
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    self.dreambookHeaderView.changeStatusCommand = self.logic.changeStatusCommand;
    self.dreambookHeaderView.toSectionCommand = self.logic.toSectionCommand;
    [self.dreambookHeaderView.statusTextField establishChannelToTextWithTerminal:self.logic.statusTerminal];
    
    @weakify(self);
    
    [RACObserve(self.logic.viewModel, posts) subscribeNext:^(id x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    RAC(self.dreambookHeaderView, viewModel) = [[RACObserve(self.logic, dreambookHeaderViewModel) ignore:nil]
        doNext:^(id<PMDreambookHeaderViewModel> viewModel) {
            @strongify(self);
            self.dreambookHeaderView.leftButtonCommand = (viewModel.isMe) ? nil : self.logic.addFriendCommand;
            self.dreambookHeaderView.rightButtonCommand = (viewModel.isMe) ? self.logic.editCommand : self.logic.getMessageCommand;
            self.dreambookHeaderView.createPostCommand = (viewModel.isMe) ? self.logic.createPostCommand : nil;
            
            [self observeForErrors];
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
    
    [[RACObserve(self.logic, dreambookHeaderViewModel.accessState)
        filter:^BOOL(NSNumber *state) {
            PMDreamerAccessState accessState = [state unsignedIntegerValue];
            return (accessState != PMDreamerAccessStateAvailable);
        }]
        subscribeNext:^(id value) {
            @strongify(self);
            self.backView.hidden = NO;
            self.dreamerStateImageView.image = self.logic.dreambookHeaderViewModel.notAvailableImage;
            self.dreamerStateLabel.text = self.logic.dreambookHeaderViewModel.dreamerStateMessage;
        }];
    
    RAC(self, navigationBarColor) = [[[RACObserve(self.logic, dreambookHeaderViewModel.statusDreamer) ignore:nil]
        map:^id(id value) {
            PMDreamerStatus status = [value unsignedIntegerValue];
            return (status == PMDreamerStatusVIP) ? [UIColor dreambookVipColor] : [UIColor dreambookNormalColor];
        }]
        doNext:^(UIColor *color) {
            @strongify(self);
            self.navigationController.navigationBar.barTintColor = color;
        }];
    
    [[RACObserve(self.logic, viewModel) ignore:nil]
        subscribeNext:^(id input) {
            @strongify(self);
            [self.tableView setContentOffset:CGPointZero animated:NO];
        }];
    
    RAC(self, title) = RACObserve(self.logic, dreambookHeaderViewModel.fullName);
}

- (void)setupLocalization
{
    [super setupLocalization];
}

- (UIView *)viewForStatesViewsConstraints
{
    return self.tableView;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.fastLinksContainer.underTabBar = YES;
    self.fastLinksContainer.style = PMFastLinksContainerControllerStyleDark;
    self.navigationController.navigationBar.barTintColor = self.navigationBarColor;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.fastLinksContainer.underTabBar = NO;
    self.fastLinksContainer.style = PMFastLinksContainerControllerStyleLight;
}

#pragma mark - PMRefreshableController

- (UIScrollView *)refreshableScrollView
{
    return self.tableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.logic.hasNextPage ? 2 : 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.logic.viewModel.posts.count;
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
        cell.viewModel = self.logic.viewModel.posts[indexPath.row];
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

#pragma mark - PMImageSelectorDelegate

- (void)imageSelector:(PMImageSelector *)imageSelector didSelectImage:(UIImage *)image croppedImage:(UIImage *)croppedImage cropRect:(CGRect)cropRect
{
    PMImageForm *imageForm = [[PMImageForm alloc] initWithImage:image croppedImage:croppedImage rect:cropRect];
    switch (self.imageSelectorType) {
        case PMImageSelectorTypeAvatar:
            [self.logic.changeAvatarCommand execute:imageForm];
            break;
        case PMImageSelectorTypeBackground:
            [self.logic.changeBackgroundCommand execute:imageForm];
            break;
        case PMImageSelectorTypeNone:
        default:
            break;
    }
}

#pragma mark - PMDreambookChangeImagesDelegate

- (void)changeImage:(PMImageSelectorType)type
{
    self.imageSelectorType = type;
    [self.imageSelector show];
}

#pragma mark - PMContainedListPhotosVCDelegate

- (void)containedListPhotoVC:(PMContainedListPhotosVC *)listPhotoVC photosLoaded:(BOOL)photosLoaded
{
    if (photosLoaded) {
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 400.0f);
    }
    else {
        self.tableView.tableHeaderView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 340.0f);
    }
}

#pragma mark - private

- (void)observeForErrors
{
    @weakify(self);
    [self.dreambookHeaderView.leftButtonCommand.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showToastViewWithTitle:error.localizedDescription buttonCommand:nil];
    }];
}

#pragma mark - actions

- (IBAction)moreButtonHandler:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *shareButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.dreambook.share", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                               }];
    [actionSheet addAction:shareButton];
    
    UIAlertAction *copyUrlButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.dreambook.copy_link", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                                   [[UIPasteboard generalPasteboard] setURL:self.logic.dreambookHeaderViewModel.dreambookUrl];
                               }];
    [actionSheet addAction:copyUrlButton];
    
    UIAlertAction *openInWebButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.dreambook.open_in_web", nil)
                                                            style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action)
                                    {
                                        [self.logic.openInWebCommand execute:self];
                                    }];
    [actionSheet addAction:openInWebButton];

    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.dreambook.cancel", nil)
                                                           style:UIAlertActionStyleCancel
                                                         handler:NULL];
    [actionSheet addAction:cancelAction];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
}

-(IBAction)prepareForUnwindMyDreamBook:(UIStoryboardSegue *)segue {}

@end
