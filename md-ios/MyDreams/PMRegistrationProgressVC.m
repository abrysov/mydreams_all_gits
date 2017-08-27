//
//  PMRegistrationProgressVC.m
//  MyDreams
//
//  Created by Иван Ушаков on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRegistrationProgressVC.h"
#import <CircleProgressBar/CircleProgressBar.h>
#import "PMRegistrationProgressLogic.h"
#import "PMRegistrationProgressViewModel.h"

@interface PMRegistrationProgressVC ()
@property (strong, nonatomic) PMRegistrationProgressLogic *logic;

@property (weak, nonatomic) IBOutlet CircleProgressBar *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation PMRegistrationProgressVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    
    self.progressBar.hintTextFont = [UIFont systemFontOfSize:15.0f];
}

- (void)setupLocalization
{
    [super setupLocalization];

    self.descriptionLabel.text = NSLocalizedString(@"auth.registration_progress.details" , nil);
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    [[RACObserve(self.logic, viewModel)
        deliverOn:[RACScheduler mainThreadScheduler]]
        subscribeNext:^(id<PMRegistrationProgressViewModel> viewModel) {
            @strongify(self);
            [self.progressBar setProgress:viewModel.progress animated:YES];
        }];
}

#pragma mark -

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.logic.registrationCommand execute:self];
}

@end
