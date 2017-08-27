//
//  PMFulfillDreamVC.m
//  myDreams
//
//  Created by AlbertA on 18/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFulfillDreamVC.h"
#import "PMFulfillDreamLogic.h"
#import "UITextField+PM.h"
#import "PMMarkWithPriceView.h"
#import "SZTextView.h"
#import "UIFont+MyDreams.h"
#import "PMRestrictionLevelButton.h"
#import "PMImageSelector.h"
#import "PMFullscreenLoadingView.h"

@interface PMFulfillDreamVC () <UITextFieldDelegate, PMImageSelectorDelegate>

@property (strong, nonatomic) PMFulfillDreamLogic *logic;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *titleDreamTextField;
@property (weak, nonatomic) IBOutlet UIButton *completionButton;

@property (weak, nonatomic) IBOutlet SZTextView *dreamDescriptionTextView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionViewingOptionsLabel;

@property (weak, nonatomic) IBOutlet UILabel *privateDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *privateFilIconImageView;
@property (weak, nonatomic) IBOutlet PMRestrictionLevelButton *privateDescriptionButton;

@property (weak, nonatomic) IBOutlet UILabel *friendsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *friendsFilIconImageView;
@property (weak, nonatomic) IBOutlet PMRestrictionLevelButton *friendsDescriptionButton;

@property (weak, nonatomic) IBOutlet UILabel *publicDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *publicFilIconImageView;
@property (weak, nonatomic) IBOutlet PMRestrictionLevelButton *publicDescriptionButton;

@property (weak, nonatomic) IBOutlet UIScrollView *marksScrollView;
@property (weak, nonatomic) IBOutlet UILabel *descriptionSelectMarkLabel;
@property (weak, nonatomic) IBOutlet PMMarkWithPriceView *bronzeMarkView;
@property (weak, nonatomic) IBOutlet PMMarkWithPriceView *silverMarkView;
@property (weak, nonatomic) IBOutlet PMMarkWithPriceView *goldMarkView;
@property (weak, nonatomic) IBOutlet PMMarkWithPriceView *platinumMarkView;
@property (weak, nonatomic) IBOutlet PMMarkWithPriceView *vipMarkView;

@property (strong, nonatomic) PMImageSelector *imageSelector;
@end

@implementation PMFulfillDreamVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    self.completionButton.rac_command = self.logic.sendDreamCommand;
    self.friendsDescriptionButton.rac_command = self.logic.changeRestrictionLevelCommand;
    self.privateDescriptionButton.rac_command = self.logic.changeRestrictionLevelCommand;
    self.publicDescriptionButton.rac_command = self.logic.changeRestrictionLevelCommand;
    
    [self.completionButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showToastViewWithTitle:error.localizedDescription buttonCommand:nil];
		[self.loadingView hide];
     }];
    
    [self.titleDreamTextField establishChannelToTextWithTerminal:self.logic.titleDreamTerminal];
    
    [RACObserve(self.logic, viewModel.photo) subscribeNext:^(UIImage *photo) {
         @strongify(self);
        self.photoImageView.image = photo;
        self.addPhotoIconImageView.hidden = (photo != nil);
     }];

    [[self.completionButton.rac_command.executionSignals switchToLatest] subscribeNext:^(id x) {
        @strongify(self);
		[self.loadingView hide];
        [self showAlertCompletionCreateDream];
    }];
    
    [RACObserve(self.logic, viewModel) subscribeNext:^(id x) {
        @strongify(self);
		[self.loadingView hide];
    }];
    
    [RACObserve(self.logic, viewModel.dreamDescription) subscribeNext:^(NSString *text) {
        @strongify(self);
        self.dreamDescriptionTextView.text = text;
    }];
    
    [[RACObserve(self.logic, viewModel.progress)
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSNumber *value) {
            @strongify(self);
			[self.loadingView setProgress:[value floatValue] animated:YES];
        }];
    
    RAC(self.privateFilIconImageView,hidden) = [RACObserve(self.logic, viewModel.restrictionLevelPrivate) map:^id(NSNumber *value) {
        return @(![value boolValue]);
    }];
    RAC(self.publicFilIconImageView,hidden) = [RACObserve(self.logic, viewModel.restrictionLevelPublic) map:^id(NSNumber *value) {
        return @(![value boolValue]);
    }];
    RAC(self.friendsFilIconImageView,hidden) = [RACObserve(self.logic, viewModel.restrictionLevelFriends) map:^id(NSNumber *value) {
        return @(![value boolValue]);
    }];
}

- (void)setupUI
{
    [super setupUI];
    self.privateDescriptionButton.restrictionLevel = PMDreamRestrictionLevelPrivate;
    self.publicDescriptionButton.restrictionLevel = PMDreamRestrictionLevelPublic;
    self.friendsDescriptionButton.restrictionLevel = PMDreamRestrictionLevelFriends;
    
    self.imageSelector = [[PMImageSelector alloc] initWithController:self needCrop:YES resizeTo:CGSizeMake(1920.0f, 1080.0f)];
    self.imageSelector.delegate = self;
    
    self.marksScrollView.scrollsToTop = NO;
    self.dreamDescriptionTextView.scrollsToTop = NO;
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"dreambook.fulfill_dream.title", nil) uppercaseString];
    self.titleDreamTextField.placeholder = NSLocalizedString(@"dreambook.fulfill_dream.dream_title_placeholder", nil);
    self.dreamDescriptionTextView.placeholder = NSLocalizedString(@"dreambook.add_dream.dream_description_placeholder", nil);
    self.descriptionViewingOptionsLabel.text = NSLocalizedString(@"dreambook.fulfill_dream.description_viewing_options", nil);
    self.privateDescriptionLabel.text = NSLocalizedString(@"dreambook.fulfill_dream.private_viewing", nil);
    self.friendsDescriptionLabel.text = NSLocalizedString(@"dreambook.fulfill_dream.friends_viewing", nil);
    self.publicDescriptionLabel.text = NSLocalizedString(@"dreambook.fulfill_dream.public_viewing", nil);
    self.descriptionSelectMarkLabel.text = NSLocalizedString(@"dreambook.fulfill_dream.description_select_mark", nil);
}

#pragma mark - actions

- (IBAction)addPhotoButtonHandler:(id)sender
{
    [self.imageSelector show];
}

- (IBAction)restrictionLevelButtonHandler:(PMRestrictionLevelButton *)button
{
    [button.rac_command execute:@(button.restrictionLevel)];
}

- (IBAction)createDreamButtonHandler:(id)sender
{
	[self.loadingView show];
    [self.view endEditing:YES];
}

-(IBAction)prepareForUnwindFulfillDream:(UIStoryboardSegue *)segue {}

#pragma mark - private

- (void)showImagePickerControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType
{
    [self.imageSelector show];
}

- (void)showAlertCompletionCreateDream
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"dreambook.fulfill_dream.successfully_created", nil)
                                                                   message:nil
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *toDreambookButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.fulfill_dream.toDreambook", nil)
                                                                style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action)
                                        {
                                            [self.logic.toDreambookCommand execute:nil];
                                        }];
    [alert addAction:toDreambookButton];
    
    UIAlertAction *newDreamButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"dreambook.fulfill_dream.create_new_dream", nil)
                                                             style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [self.logic resetData];
                                     }];
    [alert addAction:newDreamButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.logic.descriptionDream = textView.text;
}

#pragma mark - PMImageSelectorDelegate

- (void)imageSelector:(PMImageSelector *)imageSelector didSelectImage:(UIImage *)image croppedImage:(UIImage *)croppedImage cropRect:(CGRect)cropRect
{
    self.logic.photo = croppedImage;
}

@end
