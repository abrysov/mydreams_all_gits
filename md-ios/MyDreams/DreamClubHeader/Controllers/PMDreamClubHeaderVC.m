//
//  PMDreamClubHeaderPMDreamClubHeaderVC.m
//  myDreams
//
//  Created by AlbertA on 08/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamClubHeaderVC.h"
#import "PMDreamClubHeaderLogic.h"
#import "PMDreamClubHeaderViewModel.h"
#import "PMDreambookHeaderViewItemView.h"
#import "UIView+PM.h"
#import "PMContainedListPhotosLogic.h"
#import "PMDreamclubSegues.h"
#import "PMContainedListPhotosVC.h"
#import "PMDreamclubIdx.h"

@interface PMDreamClubHeaderVC () <PMContainedListPhotosVCDelegate>
@property (strong, nonatomic) PMDreamClubHeaderLogic *logic;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *shapeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *createMessageButton;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *photosItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *dreamsItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *completedItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *marksItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *friendsItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *subscribersItemView;
@property (weak, nonatomic) IBOutlet UIScrollView *headerViewItemsScrollView;
@end

@implementation PMDreamClubHeaderVC
@dynamic logic;

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [super prepareForSegue:segue sender:sender];
    if ([[segue identifier] isEqualToString:kPMSegueIdentifierToContainedListPhotosVCFromDreamclubHeaderVC]) {
        PMContainedListPhotosVC *listPhotosVC = [segue destinationViewController];
        self.logic.containerLogic = (PMBaseLogic<PMContainedListPhotosLogicDelegate> *)listPhotosVC.logic;
        [self.logic.containerLogic setupDreamerIdx:@(kPMDreamclubIdx) isMe:NO];
        listPhotosVC.delegate = self;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    self.photoImageView.cornerRadius = self.photoImageView.bounds.size.width / 2;
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.createMessageButton.rac_command = self.logic.sendMessageCommand;
    
    self.dreamsItemView.buttonCommand = self.logic.toSectionCommand;
    self.completedItemView.buttonCommand = self.logic.toSectionCommand;
    self.marksItemView.buttonCommand = self.logic.toSectionCommand;
    self.photosItemView.buttonCommand = self.logic.toSectionCommand;
    self.friendsItemView.buttonCommand = self.logic.toSectionCommand;
    self.subscribersItemView.buttonCommand = self.logic.toSectionCommand;
    
    @weakify(self);
    [RACObserve(self.logic, viewModel) subscribeNext:^(id<PMDreamClubHeaderViewModel> viewModel) {
        @strongify(self);
        [self updateUIWithViewModel:viewModel];
    }];
    
    RAC(self.photoImageView, image) = [RACObserve(self.logic, viewModel.avatar) skip:1];
    RAC(self.backgroundImageView, image) = [RACObserve(self.logic, viewModel.background) skip:1];
}

- (void)setupUI
{
    [super setupUI];
    self.dreamsItemView.type = PMDreambookHeaderViewItemTypeDreams;
    self.completedItemView.type = PMDreambookHeaderViewItemTypeFulfilledDreams;
    self.marksItemView.type = PMDreambookHeaderViewItemTypeMarks;
    self.photosItemView.type = PMDreambookHeaderViewItemTypePhotos;
    self.friendsItemView.type = PMDreambookHeaderViewItemTypeFriends;
    self.subscribersItemView.type = PMDreambookHeaderViewItemTypeSubscribers;
    
    self.headerViewItemsScrollView.scrollsToTop = NO;
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.dreamsItemView.title = [NSLocalizedString(@"dreamclub.dreamclub_header.dreams", nil) uppercaseString];
    self.completedItemView.title = [NSLocalizedString(@"dreamclub.dreamclub_header.completed", nil) uppercaseString];
    self.marksItemView.title = [NSLocalizedString(@"dreamclub.dreamclub_header.marks", nil) uppercaseString];
    self.photosItemView.title = [NSLocalizedString(@"dreamclub.dreamclub_header.photos", nil) uppercaseString];
    self.friendsItemView.title = [NSLocalizedString(@"dreamclub.dreamclub_header.friends", nil) uppercaseString];
    self.subscribersItemView.title = [NSLocalizedString(@"dreamclub.dreamclub_header.subscribers", nil) uppercaseString];
    [self.createMessageButton setTitle:NSLocalizedString(@"dreamclub.dreamclub_header.create_message_button_title", nil) forState:UIControlStateNormal];
}

#pragma mark - PMContainedListPhotosVCDelegate

- (void)containedListPhotoVC:(PMContainedListPhotosVC *)listPhotoVC photosLoaded:(BOOL)photosLoaded
{
    [self.delegate dreamclubHeaderVC:self photosLoaded:photosLoaded];
}

#pragma mark - private

- (void)updateUIWithViewModel:(id<PMDreamClubHeaderViewModel>) viewModel
{
    self.titleLabel.text = viewModel.fullName;
    self.descriptionLabel.text = viewModel.status;
    self.photosItemView.count = viewModel.photosCount;
    self.dreamsItemView.count = viewModel.dreamsCount;
    self.friendsItemView.count = viewModel.friendsCount;
    self.completedItemView.count = viewModel.completedCount;
    self.marksItemView.count = viewModel.marksCount;
    self.subscribersItemView.count = viewModel.subscribersCount;
}

-(IBAction)prepareForUnwindDreamClubHeader:(UIStoryboardSegue *)segue {}

@end
