//
//  PMCreatePostVC.m
//  myDreams
//
//  Created by AlbertA on 28/06/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCreatePostVC.h"
#import "PMCreatePostLogic.h"
#import "PMImageSelector.h"
#import "CircleProgressBar.h"
#import "SZTextView.h"
#import "UIFont+MyDreams.h"
#import "PMFullscreenLoadingView.h"

@interface PMCreatePostVC ()  <UITextViewDelegate, PMImageSelectorDelegate>
@property (strong, nonatomic) PMCreatePostLogic *logic;
@property (weak, nonatomic) IBOutlet UIButton *addPhotoButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoIconImageView;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
@property (weak, nonatomic) IBOutlet SZTextView *postDescriptionTextView;

@property (strong, nonatomic) PMImageSelector *imageSelector;
@end

@implementation PMCreatePostVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    self.sendButton.rac_command = self.logic.sendPostCommand;
    
    @weakify(self);
    [self.sendButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showToastViewWithTitle:error.localizedDescription buttonCommand:nil];
		[self.loadingView hide];
    }];

    [[RACObserve(self.logic, viewModel.photo) ignore:nil]
        subscribeNext:^(UIImage *photo) {
            @strongify(self);
            self.photoImageView.image = photo;
            self.addPhotoIconImageView.hidden = (photo != nil);
        }];
    
    RAC(self.sendButton, alpha) = [RACObserve(self.sendButton, enabled) map:^id(NSNumber *value) {
        return [value boolValue] ? @(1.0f) : @(0.3f);
    }];
    
    [[RACObserve(self.logic, viewModel.progress)
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSNumber *value) {
            @strongify(self);
			[self.loadingView setProgress:[value floatValue] animated:YES];
        }];

	[[self.sendButton.rac_command.executionSignals switchToLatest] subscribeNext:^(id x) {
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
    self.title = [NSLocalizedString(@"dreambook.create_post.title", nil) uppercaseString];
    self.postDescriptionTextView.placeholder = NSLocalizedString(@"dreambook.create_post.post_description_placeholder", nil);
    [self.sendButton setTitle:NSLocalizedString(@"dreambook.create_post.send_button_title", nil) forState:UIControlStateNormal];
}

#pragma mark - actions

- (IBAction)addPhotoButtonHandler:(id)sender
{
    [self.imageSelector show];
}

- (IBAction)sendPost:(id)sender
{
	[self.loadingView show];
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.logic.postDescription = textView.text;
}

#pragma mark - PMImageSelectorDelegate

- (void)imageSelector:(PMImageSelector *)imageSelector didSelectImage:(UIImage *)image croppedImage:(UIImage *)croppedImage cropRect:(CGRect)cropRect
{
    self.logic.photo = croppedImage;
}

#pragma mark - private

-(IBAction)prepareForUnwindCreatePost:(UIStoryboardSegue *)segue {}

@end
