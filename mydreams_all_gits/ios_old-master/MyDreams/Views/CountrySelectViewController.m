//
//  CountrySelectViewController.m
//  MyDreams
//
//  Created by Игорь on 26.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "CountrySelectViewController.h"
#import "ApiDataManager.h"
#import "LocationCell.h"
#import "CommonTextField.h"

@interface CountrySelectViewController ()

@end

@implementation CountrySelectViewController {
    NSArray *countries;
    NSArray *allCountries;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.countryTable.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self performLoading];
}

- (void)performLoading {
    [ApiDataManager countries:nil
                      success:^(NSArray<Location> *locations_) {
                          allCountries = locations_;
                          [self applyFilter:nil];
                      } error:^(NSString *err) {
                          [self showAlert:err];
                      }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.countryTextField) {
        CommonTextField *tf = (CommonTextField *)textField;
        NSString *search = [tf.text stringByReplacingCharactersInRange:range withString:string];
        [self applyFilter:search];
    }
    return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (void)applyFilter:(NSString *)filter {
    countries = filter && [filter length] > 0
        ? [allCountries filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.name BEGINSWITH[cd] %@", filter]]
        : [NSArray arrayWithArray:allCountries];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.countryTable reloadData];
    });
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
    if (cell == nil) {
        [self.countryTable registerNib:[UINib nibWithNibName:@"CountryCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
    }
    
    Location *location = countries[indexPath.row];
    cell.locationNameLabel.text = location.name;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 38;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [countries count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"itemClick: position = %ld", (long)indexPath.row);
    
    Location *selectedCountry = [countries objectAtIndex:indexPath.row];
    NSLog(@"selectedCountry id %ld", (long)selectedCountry.id);
    NSLog(@"selectedCountry name %@", selectedCountry.name);
    
    [self.delegate didCountrySelect:selectedCountry];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTouch:(id)sender {
    [self.delegate didCountrySelectCancel];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
