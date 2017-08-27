//
//  PMAddDreamVC.m
//  myDreams
//
//  Created by AlbertA on 16/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAddFulfilledDreamVC.h"
#import "PMAddFulfilledDreamLogic.h"
#import "PMDreamForm.h"
#import "PMAddSuccessfulDreamViewModel.h"
#import "SZTextView.h"
#import "UITextField+PM.h"
#import "UIFont+MyDreams.h"
#import "PMImageSelector.h"
#import "PMFullscreenLoadingView.h"

@interface PMAddFulfilledDreamVC () <UITextViewDelegate, PMImageSelectorDelegate>

@property (strong, nonatomic) PMAddFulfilledDreamLogic *logic;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UITextField *titleDreamTextField;
@property (weak, nonatomic) IBOutlet UIButton *completionButton;
@property (weak, nonatomic) IBOutlet SZTextView *dreamDescriptionTextView;

@property (strong, nonatomic) PMImageSelector *imageSelector;
@end

@implementation PMAddFulfilledDreamVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    self.completionButton.rac_command = self.logic.sendDreamCommand;
    [self.titleDreamTextField establishChannelToTextWithTerminal:self.logic.titleDreamTerminal];
    
    @weakify(self);
    [[RACObserve(self.logic, viewModel.photo) ignore:nil]
         subscribeNext:^(UIImage *photo) {
             @strongify(self);
             self.photoImageView.image = photo;
             self.addPhotoIconImageView.hidden = YES;
         }];
    
    RAC(self.completionButton, alpha) = [RACObserve(self.completionButton, enabled) map:^id(NSNumber *value) {
        return [value boolValue] ? @(1.0f) : @(0.3f);
    }];
    
    [[RACObserve(self.logic, viewModel.progress)
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSNumber *value) {
            @strongify(self);
            [self.loadingView setProgress:[value floatValue] animated:YES];
        }];
	
	[[self.completionButton.rac_command.executionSignals switchToLatest] subscribeNext:^(id x) {
		@strongify(self);
		[self.loadingView hide];
	}];
}

- (void)setupUI
{
    [super setupUI];
    
    self.imageSelector = [[PMImageSelector alloc] initWithController:self needCrop:YES resizeTo:CGSizeMake(1920.0f, 1080.0f)];
    self.imageSelector.delegate = self;
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.title = [NSLocalizedString(@"dreambook.add_dream.title", nil) uppercaseString];
    self.titleDreamTextField.placeholder = NSLocalizedString(@"dreambook.add_dream.dream_title_placeholder", nil);
    self.dreamDescriptionTextView.placeholder = NSLocalizedString(@"dreambook.add_dream.dream_description_placeholder", nil);
    [self.completionButton setTitle:[NSLocalizedString(@"dreambook.add_dream.send_button_title", nil) uppercaseString] forState:UIControlStateNormal];
}

#pragma mark - actions

- (IBAction)addPhotoButtonHandler:(id)sender
{
    [self.imageSelector show];
}

- (IBAction)sendFulfilledDream:(id)sender
{
	[self.loadingView show];
    [self.view endEditing:YES];
}

-(IBAction)prepareForUnwindAddDream:(UIStoryboardSegue *)segue {}

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
