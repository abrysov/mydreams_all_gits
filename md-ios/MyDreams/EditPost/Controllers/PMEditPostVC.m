//
//  PMEditPostVC.m
//  myDreams
//
//  Created by AlbertA on 01/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditPostVC.h"
#import "PMEditPostLogic.h"
#import "SZTextView.h"
#import "PMImageSelector.h"
#import "PMFullscreenLoadingView.h"
#import "PMEditPostViewModel.h"

@interface PMEditPostVC () <PMImageSelectorDelegate>
@property (strong, nonatomic) PMEditPostLogic *logic;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet SZTextView *descriptionTextView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *backBarButtonItem;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *photoActivity;
@property (weak, nonatomic) IBOutlet UIImageView *addPhotoImageView;

@property (strong, nonatomic) PMImageSelector *imageSelector;
@end

@implementation PMEditPostVC
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
    
    RAC(self.descriptionTextView, text) = RACObserve(self.logic, viewModel.postDescription);
    RAC(self.photoImageView, image) = [RACObserve(self.logic, viewModel.photo)
        doNext:^(id photo) {
            @strongify(self);
            self.addPhotoImageView.hidden = YES;
            [self.photoActivity stopAnimating];
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
    self.title = [NSLocalizedString(@"dreambook.edit_post.title", nil) uppercaseString];
    self.descriptionTextView.placeholder = NSLocalizedString(@"dreambook.edit_post.content_placeholder", nil);
    [self.saveButton setTitle:NSLocalizedString(@"dreambook.edit_post.save_button_title", nil) forState:UIControlStateNormal];
}

#pragma mark - actions

- (IBAction)addPhotoButtonHandler:(id)sender
{
    [self.imageSelector show];
}

- (IBAction)savePost:(id)sender
{
    [self.loadingView show];
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView
{
    [self.logic setupContent:textView.text];
}

#pragma mark - PMImageSelectorDelegate

- (void)imageSelector:(PMImageSelector *)imageSelector didSelectImage:(UIImage *)image croppedImage:(UIImage *)croppedImage cropRect:(CGRect)cropRect
{
    [self.logic setupPhoto:croppedImage];
}

#pragma mark - private

-(IBAction)prepareForUnwindEditPost:(UIStoryboardSegue *)segue {}

@end
