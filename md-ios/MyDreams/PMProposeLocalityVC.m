//
//  PMSelectLocalityVC.m
//  myDreams
//
//  Created by AlbertA on 24/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "UITextField+PM.h"
#import "PMProposeLocalityVC.h"
#import "PMProposeLocalityLogic.h"
#import "PMAlertManager.h"
#import "PMCellFillView.h"
#import "PMLocalityCell.h"
#import "AuthentificationTableViewCells.h"

@interface PMProposeLocalityVC ()
@property (strong, nonatomic) PMProposeLocalityLogic *logic;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet PMCellFillView *enterRegionView;
@property (weak, nonatomic) IBOutlet PMCellFillView *enterAreaView;
@property (weak, nonatomic) IBOutlet UILabel *moreInfoLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendLocalityButton;

@end

@implementation PMProposeLocalityVC
@dynamic logic;

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    self.backButton.rac_command = self.logic.backCommand;
    self.sendLocalityButton.rac_command = self.logic.sendLocalityCommand;
    [self.searchTextField establishChannelToTextWithTerminal:self.logic.searchTerminal];
    [self.enterRegionView.valueTextField establishChannelToTextWithTerminal:self.logic.regionTerminal];
    [self.enterAreaView.valueTextField establishChannelToTextWithTerminal:self.logic.destrictTerminal];
    
    [self.alertManager processErrorsOfCommand:self.sendLocalityButton.rac_command in:self];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.searchTextField.placeholder = NSLocalizedString(@"auth.propose_locality.name_locality_placeholder", nil);
    self.titleLabel.text = [NSLocalizedString(@"auth.propose_locality.title", nil) uppercaseString];
    [self.enterAreaView.titleButton setTitle:NSLocalizedString(@"auth.propose_locality.enter_area_description", nil) forState:UIControlStateNormal];
    [self.enterRegionView.titleButton setTitle:NSLocalizedString(@"auth.propose_locality.enter_region_description", nil) forState:UIControlStateNormal];
    self.moreInfoLabel.text = NSLocalizedString(@"auth.propose_locality.more_info_description", nil);
    [self.sendLocalityButton setTitle:[NSLocalizedString(@"auth.propose_locality.send_locality_button_title", nil) uppercaseString] forState:UIControlStateNormal];
}

#pragma mark - private

- (IBAction)prepareForUnwindSelectLocality:(UIStoryboardSegue *)segue {}

@end
