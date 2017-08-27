//
//  PMSelectLocalityVC.m
//  myDreams
//
//  Created by AlbertA on 24/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSelectLocalityVC.h"
#import "PMSelectLocalityLogic.h"
#import "PMCellFillView.h"
#import "UITextField+PM.h"
#import "PMLocalityCell.h"
#import "PMLocalityViewModel.h"
#import "AuthentificationTableViewCells.h"

@interface PMSelectLocalityVC ()
@property (strong, nonatomic) PMSelectLocalityLogic *logic;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITableView *selectionLocationTableView;
@property (weak, nonatomic) IBOutlet UIButton *showFormOfferLocalityButton;

@end

@implementation PMSelectLocalityVC
@dynamic logic;

- (void)setupUI
{
    [super setupUI];
    self.isStateViewTransparent = YES;
    self.stateViewTextColor = [UIColor whiteColor];
}

- (void)bindUIWithLogics
{
    [super bindUIWithLogics];
    @weakify(self);
    
    self.backButton.rac_command = self.logic.backCommand;
    [self.searchTextField establishChannelToTextWithTerminal:self.logic.searchTerminal];
    self.showFormOfferLocalityButton.rac_command = self.logic.showProposeLocalityCommand;
    [[RACObserve(self.logic, localitiesViewModel)
        ignore:nil]
        subscribeNext:^(id input) {
            @strongify(self);
            [self.selectionLocationTableView reloadData];
        }];
}

- (void)setupLocalization
{
    [super setupLocalization];
    self.searchTextField.placeholder = NSLocalizedString(@"auth.select_locality.search_locality_placeholder", nil);
    self.titleLabel.text = [NSLocalizedString(@"auth.select_locality.title", nil) uppercaseString];
    [self.showFormOfferLocalityButton setTitle:[NSLocalizedString(@"auth.select_locality.show_offer_locality_button_title", nil) uppercaseString] forState:UIControlStateNormal];
}

- (UIView *)viewForStatesViewsConstraints
{
    return self.selectionLocationTableView;
}

#pragma - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.logic selectLocalityWithIndex:indexPath.row];
}

#pragma - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logic.localitiesViewModel.localities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMLocalityCell *cell = (PMLocalityCell *)[tableView dequeueReusableCellWithIdentifier:self.cell.kPMReuseIdentifierLocalityCell];
    cell.viewModel = self.logic.localitiesViewModel.localities[indexPath.row];
    return cell;
}

#pragma mark - private

- (IBAction)prepareForUnwindSelectLocality:(UIStoryboardSegue *)segue {}

@end
