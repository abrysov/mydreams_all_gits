//
//  PMAddLocalityVC.m
//  myDreams
//
//  Created by AlbertA on 24/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSuccessfulProposalLocalityVC.h"
#import "PMSuccessfulProposalLocalityLogic.h"

@interface PMSuccessfulProposalLocalityVC ()
@property (strong, nonatomic) PMSuccessfulProposalLocalityLogic *logic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *localityDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIButton *localityButton;
@property (weak, nonatomic) IBOutlet UILabel *regionLabel;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@end

@implementation PMSuccessfulProposalLocalityVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    self.nextButton.rac_command = self.logic.backToRegistrationCommand;
    
    [RACObserve(self.logic, customLocality)
        subscribeNext:^(id<PMCustomLocalityViewModel> customLocality) {
            @strongify(self);
            [self.localityButton setTitle:customLocality.name forState:UIControlStateNormal];
            self.regionLabel.text = customLocality.region;
            self.areaLabel.text = customLocality.district;
        }];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.titleLabel.text = [NSLocalizedString(@"auth.successful_proposal_locality.title", nil) uppercaseString];
    self.localityDescriptionLabel.text = NSLocalizedString(@"auth.successful_proposal_locality.locality_description", nil);
    [self.nextButton setTitle:[NSLocalizedString(@"auth.successful_proposal_locality.next_button_title", nil) uppercaseString] forState:UIControlStateNormal];
}

#pragma mark - private

- (IBAction)prepareForUnwindAddLocality:(UIStoryboardSegue *)segue {}

@end
