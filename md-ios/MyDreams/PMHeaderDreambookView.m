//
//  PMHeaderDreambookView.m
//  MyDreams
//
//  Created by user on 18.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreambookBorderedButton.h"
#import "PMHeaderDreambookView.h"
#import "PMDreambookHeaderViewItemView.h"
#import "UIColor+MyDreams.h"
#import "PMDreambookHeaderViewItemType.h"

@interface PMHeaderDreambookView () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UILabel *detailsDreamerLabel;
@property (weak, nonatomic) IBOutlet UIImageView *genderImageView;
@property (weak, nonatomic) IBOutlet UIImageView *indicatorOnlineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shapeIconImageView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *dreamsItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *completedItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *marksItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *photosItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *friendsItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *subsribersItemView;
@property (weak, nonatomic) IBOutlet PMDreambookHeaderViewItemView *subscriptionsItemView;
@property (weak, nonatomic) IBOutlet UIButton *postsFilterButton;
@property (weak, nonatomic) IBOutlet PMDreambookBorderedButton *leftButton;
@property (weak, nonatomic) IBOutlet PMDreambookBorderedButton *rightButton;
@property (weak, nonatomic) IBOutlet PMDreambookBorderedButton *createPostButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *trailingLocationLabelAndSuperViewConstraint;
@property (weak, nonatomic) IBOutlet UIView *plusIconView;
@property (weak, nonatomic) IBOutlet UIButton *changeAvatarButton;
@property (weak, nonatomic) IBOutlet UIScrollView *headerViewItemViewScrollView;
@end

@implementation PMHeaderDreambookView

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if ((self = [super initWithCoder:aDecoder])) {
        UIView *view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:self options:nil] objectAtIndex:0];
        [self addSubview:view];
        
        @weakify(self);
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            @strongify(self);
            make.edges.equalTo(self);
        }];
        
        [self setupUI];
        [self setupLocalization];
        self.leftButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        self.rightButton.titleLabel.adjustsFontSizeToFitWidth = YES;
        
        self.headerViewItemViewScrollView.scrollsToTop = NO;
        self.statusTextField.delegate = self;
    }
    return self;
}

- (void)layoutSubviews
{
    self.photoImageView.layer.cornerRadius = self.photoImageView.frame.size.height / 2;
}

#pragma mark - properties

- (void)setRightButtonCommand:(RACCommand *)rightButtonCommand
{
    self->_rightButtonCommand = rightButtonCommand;
    self.rightButton.rac_command = rightButtonCommand;
}

- (void)setLeftButtonCommand:(RACCommand *)leftButtonCommand
{
    self->_leftButtonCommand = leftButtonCommand;
    self.leftButton.rac_command = leftButtonCommand;
}

- (void)setCreatePostCommand:(RACCommand *)createPostCommand
{
    self->_createPostCommand = createPostCommand;
    self.createPostButton.rac_command = createPostCommand;
}

- (void)setToSectionCommand:(RACCommand *)toSectionCommand
{
    self->_toSectionCommand = toSectionCommand;
    
    self.dreamsItemView.buttonCommand = toSectionCommand;
    self.completedItemView.buttonCommand = toSectionCommand;
    self.marksItemView.buttonCommand = toSectionCommand;
    self.photosItemView.buttonCommand = toSectionCommand;
    self.friendsItemView.buttonCommand = toSectionCommand;
    self.subsribersItemView.buttonCommand = toSectionCommand;
    self.subscriptionsItemView.buttonCommand = toSectionCommand;
}

- (void)setViewModel:(id<PMDreambookHeaderViewModel>)viewModel
{
    self.photoImageView.image = viewModel.defaultPhoto;

    @weakify(self);
    RAC(self.detailsDreamerLabel, text) = [RACObserve(viewModel, detailsDreamer) distinctUntilChanged];
    RAC(self.genderImageView, image) = [RACObserve(viewModel, genderImage) distinctUntilChanged];
    RAC(self.statusTextField, text) = [[RACObserve(viewModel, status) distinctUntilChanged] doNext:^(NSString *value) {
        @strongify(self);
        if (viewModel.isMe) {
            self.statusTextField.inputState = [value isEqualToString:@""] ? PMStatusTextFieldInputStateClear : PMStatusTextFieldInputStateFull;
        }
    }];
    
    RAC(self.photosItemView, count) = [RACObserve(viewModel, photosCount) distinctUntilChanged];
    RAC(self.dreamsItemView, count) = [RACObserve(viewModel, dreamsCount) distinctUntilChanged];
    RAC(self.friendsItemView, count) = [RACObserve(viewModel, friendsCount) distinctUntilChanged];
    RAC(self.completedItemView, count) = [RACObserve(viewModel, completedCount) distinctUntilChanged];
    RAC(self.marksItemView, count) = [RACObserve(viewModel, marksCount) distinctUntilChanged];
    RAC(self.subsribersItemView, count) = [RACObserve(viewModel, subscribersCount) distinctUntilChanged];
    RAC(self.subscriptionsItemView, count) = [RACObserve(viewModel, subscriptionsCount) distinctUntilChanged];
    
    RAC(self.photoImageView, image) = [RACObserve(viewModel, avatar) distinctUntilChanged];
    RAC(self.backgroundImageView, image) = [RACObserve(viewModel, background) distinctUntilChanged];
    
    [RACObserve(viewModel, postsCount) subscribeNext:^(NSString *postsCount) {
        @strongify(self);
        [self.postsFilterButton setTitle:postsCount forState:UIControlStateNormal];
    }];
    
    [[RACObserve(viewModel, statusDreamer) distinctUntilChanged] subscribeNext:^(NSNumber *status) {
        @strongify(self);
        PMDreamerStatus dreamerStatus = [status unsignedIntegerValue];
        [self buildUIForStatus:dreamerStatus];
        
        if (viewModel.isMe) {
            [self buildUIForMy];
        }
        else {
            [self buildUIForForeignWithViewModel:viewModel];
        }
    }];

    self.plusIconView.hidden = !viewModel.isMe;
    
    if (viewModel.isMe) {
        [self.leftButton addTarget:self
                            action:@selector(changeBackground)
                  forControlEvents:UIControlEventTouchUpInside];
        [self.changeAvatarButton addTarget:self
                                    action:@selector(changeAvatar)
                          forControlEvents:UIControlEventTouchUpInside];
    }
    
    RAC(self.indicatorOnlineImageView, hidden) = [[RACObserve(viewModel, isOnline) distinctUntilChanged] map:^id(NSNumber *value) {
        return @(![value boolValue]);
    }];
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField setContentHuggingPriority:2 forAxis:UILayoutConstraintAxisHorizontal];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [textField setContentHuggingPriority:501 forAxis:UILayoutConstraintAxisHorizontal];
}

#pragma mark - actions

- (IBAction)statusTextFieldEditingDidEnd:(UITextField *)textField
{
    [self.changeStatusCommand execute:nil];
}

#pragma mark - private

- (void)setupUI
{
    self.indicatorOnlineImageView.image = [[UIImage imageNamed:@"online_icon"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    self.dreamsItemView.type = PMDreambookHeaderViewItemTypeDreams;
    self.completedItemView.type = PMDreambookHeaderViewItemTypeFulfilledDreams;
    self.marksItemView.type = PMDreambookHeaderViewItemTypeMarks;
    self.photosItemView.type = PMDreambookHeaderViewItemTypePhotos;
    self.friendsItemView.type = PMDreambookHeaderViewItemTypeFriends;
    self.subsribersItemView.type = PMDreambookHeaderViewItemTypeSubscribers;
    self.subscriptionsItemView.type = PMDreambookHeaderViewItemTypeSubscriptions;
}

- (void)buildUIForStatus:(PMDreamerStatus)status
{
    UIColor *colorForStatus = (status == PMDreamerStatusVIP) ? [UIColor dreambookVipColor] : [UIColor dreambookNormalColor];
    self.shapeIconImageView.hidden = (status == PMDreamerStatusDefault);
    self.trailingLocationLabelAndSuperViewConstraint.priority = (status == PMDreamerStatusVIP) ? 500 : 999;
    self.createPostButton.dreamerStatus = status;
    self.leftButton.dreamerStatus = status;
    self.rightButton.dreamerStatus = status;
    self.backgroundImageView.backgroundColor = colorForStatus;
    [self setTintColor:colorForStatus];
}

- (void)buildUIForMy
{
    self.leftButton.inputState = PMDreambookBorderedButtonStateDefault;
    [self.leftButton setTitle:NSLocalizedString(@"dreambook.header.change_background", nil) forState:UIControlStateNormal];
    self.rightButton.inputState = PMDreambookBorderedButtonStateDefault;
    [self.rightButton setTitle:NSLocalizedString(@"dreambook.header.edit", nil) forState:UIControlStateNormal];
    
    self.statusTextField.enabled = YES;
    self.createPostButton.inputState = PMDreambookBorderedButtonStateFilled;
    self.createPostButton.hidden = NO;
    self.subscriptionsItemView.hidden = NO;
}

- (void)buildUIForForeign
{
    self.leftButton.inputState = PMDreambookBorderedButtonStateBordered;
    [self.leftButton setTitle:NSLocalizedString(@"dreambook.header.subscribe", nil) forState:UIControlStateNormal];
    self.rightButton.inputState = PMDreambookBorderedButtonStateFilled;
    [self.rightButton setTitle:NSLocalizedString(@"dreambook.header.message", nil) forState:UIControlStateNormal];
    
    self.statusTextField.enabled = NO;
    self.createPostButton.hidden = YES;
    self.subscriptionsItemView.hidden = YES;
}

- (void)buildUIForForeignWithViewModel:(id<PMDreambookHeaderViewModel>)viewModel
{
    [self buildUIForForeign];
    
    @weakify(self);
    [RACObserve(viewModel, subscriptionType) subscribeNext:^(NSNumber *type) {
        PMDreamerSubscriptionType subscriptionType = [type unsignedIntegerValue];
        switch (subscriptionType) {
            case PMDreamerSubscriptionTypeSubscriber: {
                @strongify(self);
                self.leftButton.inputState = PMDreambookBorderedButtonStateBorderedWithIcon;
                [self.leftButton setTitle:NSLocalizedString(@"dreambook.header.subscriber", nil) forState:UIControlStateNormal];
                break;
            }
            case PMDreamerSubscriptionTypeFriend: {
                @strongify(self);
                self.leftButton.inputState = PMDreambookBorderedButtonStateBorderedWithIcon;
                [self.leftButton setTitle:NSLocalizedString(@"dreambook.header.friends", nil) forState:UIControlStateNormal];
                break;
            }
            case PMDreamerSubscriptionTypeNope:
            default: {
                @strongify(self);
                self.leftButton.inputState = PMDreambookBorderedButtonStateBordered;
                [self.leftButton setTitle:NSLocalizedString(@"dreambook.header.subscribe", nil) forState:UIControlStateNormal];
                break;
            }
        }
    }];
}

- (void)setupLocalization
{
    self.dreamsItemView.title = [NSLocalizedString(@"dreambook.header.dreams", nil) uppercaseString];
    self.completedItemView.title = [NSLocalizedString(@"dreambook.header.completed", nil) uppercaseString];
    self.marksItemView.title = [NSLocalizedString(@"dreambook.header.marks", nil) uppercaseString];
    self.photosItemView.title = [NSLocalizedString(@"dreambook.header.photos", nil) uppercaseString];
    self.friendsItemView.title = [NSLocalizedString(@"dreambook.header.friends", nil) uppercaseString];
    self.subsribersItemView.title = [NSLocalizedString(@"dreambook.header.subscribers", nil) uppercaseString];
    self.subscriptionsItemView.title = [NSLocalizedString(@"dreambook.header.subscriptions", nil) uppercaseString];
    [self.createPostButton setTitle:NSLocalizedString(@"dreambook.header.create_note", nil) forState:UIControlStateNormal];
}

- (void)changeBackground
{
    [self.delegate changeImage:PMImageSelectorTypeBackground];
}

- (void)changeAvatar
{
    [self.delegate changeImage:PMImageSelectorTypeAvatar];
}


@end
