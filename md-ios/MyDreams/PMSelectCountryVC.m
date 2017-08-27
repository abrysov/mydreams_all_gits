//
//  PMRegistrationSelectionLocation.m
//  MyDreams
//
//  Created by user on 18.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSelectCountryVC.h"
#import "PMSelectCountryLogic.h"
#import "PMCountyCell.h"
#import "UITextField+PM.h"
#import "PMCountryViewModelImpl.h"
#import "AuthentificationTableViewCells.h"

@interface PMSelectCountryVC ()
@property (strong, nonatomic) PMSelectCountryLogic *logic;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;
@property (weak, nonatomic) IBOutlet UITableView *selectionLocationTableView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation PMSelectCountryVC
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

    [[RACObserve(self.logic, countriesViewModel)
        ignore:nil]
        subscribeNext:^(id input) {
            @strongify(self);
            [self.selectionLocationTableView reloadData];
        }];
}

- (void)setupLocalization
{
    [super setupLocalization];
    
    self.searchTextField.placeholder = NSLocalizedString(@"auth.select_country.search_placeholder", nil);
    self.titleLabel.text = [NSLocalizedString(@"auth.select_country.title", nil) uppercaseString];
}

- (UIView *)viewForStatesViewsConstraints
{
    return self.selectionLocationTableView;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.logic.countriesViewModel.countries.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PMCountyCell *cell = (PMCountyCell *)[tableView dequeueReusableCellWithIdentifier:self.cell.kPMReuseIdentifierCountryCell];
    cell.viewModel = self.logic.countriesViewModel.countries[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.logic selectCountryWithIndex:indexPath.row];
}

@end
