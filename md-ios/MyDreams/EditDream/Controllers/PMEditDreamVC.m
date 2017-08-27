//
//  PMEditDreamVC.m
//  myDreams
//
//  Created by AlbertA on 25/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditDreamVC.h"
#import "PMEditDreamLogic.h"
#import "SZTextView.h"
#import "PMImageSelector.h"
#import "PMFullscreenLoadingView.h"
#import "PMEditDreamViewModel.h"

@interface PMEditDreamVC () <PMImageSelectorDelegate>
@property (strong, nonatomic) PMEditDreamLogic *logic;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet SZTextView *titleTextView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet SZTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *photoActivity;

@property (strong, nonatomic) PMImageSelector *imageSelector;
@end

@implementation PMEditDreamVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.backBarButtonItem.rac_command = self.logic.backCommand;
    self.saveButton.rac_command = self.logic.saveDreamCommand;   

    @weakify(self);
    [[RACObserve(self.logic, viewModel.progress)
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(NSNumber *value) {
            @strongify(self);
            [self.loadingView setProgress:[value floatValue] animated:YES];
        }];
    
    [[self.saveButton.rac_command.executionSignals switchToLatest] subscribeNext:^(id x) {
        @strongify(self);
        [self.loadingView hide];
    }];
    
    [self.saveButton.rac_command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showToastViewWithTitle:error.localizedDescription buttonCommand:nil];
        [self.loadingView hide];
    }];
    
    RAC(self.titleTextView, text) = RACObserve(self.logic, viewModel.dreamTitle);
    RAC(self.descriptionTextView, text) = RACObserve(self.logic, viewModel.dreamDescription);
    RAC(self.photoImageView, image) = [[RACObserve(self.logic, viewModel.photo)
        doNext:^(id photo) {
            @strongify(self);
            self.photoImageView.contentMode = photo ? UIViewContentModeScaleAspectFill : UIViewContentModeCenter;
            [self.photoActivity stopAnimating];
        }]
        filter:^BOOL(id value) {
            return value ? YES : NO;
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
    self.title = [NSLocalizedString(@"dreambook.edit_dream.title", nil) uppercaseString];
    self.titleTextView.placeholder = NSLocalizedString(@"dreambook.edit_dream.dream_title_placeholder", nil);
    self.descriptionTextView.placeholder = NSLocalizedString(@"dreambook.edit_dream.dream_description_placeholder", nil);
    [self.saveButton setTitle:NSLocalizedString(@"dreambook.edit_dream.save_button_title", nil) forState:UIControlStateNormal];
}

#pragma mark - actions

- (IBAction)addPhotoButtonHandler:(id)sender
{
    [self.imageSelector show];
}

- (IBAction)saveDream:(id)sender
{
    [self.loadingView show];
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    if ([textView isEqual:self.titleTextView]) {
        [self.logic setupDreamTitle:textView.text];
    }
    else if ([textView isEqual:self.descriptionTextView]) {
        [self.logic setupDreamDescription:textView.text];
    }
}

#pragma mark - PMImageSelectorDelegate

- (void)imageSelector:(PMImageSelector *)imageSelector didSelectImage:(UIImage *)image croppedImage:(UIImage *)croppedImage cropRect:(CGRect)cropRect
{
    [self.logic setupPhoto:croppedImage cropRect:cropRect];
}

#pragma mark - private

-(IBAction)prepareForUnwindEditDream:(UIStoryboardSegue *)segue {}

@end
