//
//  LocationSelectViewController.m
//  MyDreams
//
//  Created by Игорь on 12.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "LocationSelectViewController.h"
#import "LocationCell.h"
#import "Location.h"
#import "ApiDataManager.h"

@interface LocationSelectViewController ()

@end

@implementation LocationSelectViewController {
    NSArray *locations;
    NSTimer *searchTimer;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.locationsTable.tableFooterView = [[UIView alloc] init];
    self.nothingLabel.hidden = YES;
    
    [self performLoading:@""];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.locationTextField) {
        CommonTextField *tf = (CommonTextField *)textField;
        NSString *search = [tf.text stringByReplacingCharactersInRange:range withString:string];
        
        if (searchTimer) {
            [searchTimer invalidate];
            searchTimer = nil;
        }
        searchTimer = [NSTimer scheduledTimerWithTimeInterval:0.5
                                                       target:self
                                                     selector:@selector(handleSearchTimer:)
                                                     userInfo:search
                                                      repeats:NO];
    }
    return [super textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

-(void)handleSearchTimer:(NSTimer *)timer {
    [self performLoading:(NSString *)timer.userInfo];
}

- (void)performLoading:(NSString *)search {
    if ([search length] < 3)
        return;
    [ApiDataManager findlocations:search
                          country:self.country
                              lat:0
                              lng:0
                          success:^(NSArray<Location> *locations_) {
                              
        locations = locations_;
        self.nothingLabel.hidden = locations && locations.count > 0;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.locationsTable reloadData];
        });
    } error:^(NSString *err) {
        [self showAlert:err];
    }];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LocationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
    if (cell == nil) {
        [self.locationsTable registerNib:[UINib nibWithNibName:@"LocationCell" bundle:nil] forCellReuseIdentifier:@"locationCell"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"locationCell"];
    }
    
    Location *location = locations[indexPath.row];
    cell.locationNameLabel.text = location.name;
    cell.locationParentLabel.text = location.parent;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 46;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [locations count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"itemClick: position = %ld", (long)indexPath.row);
    
    Location *selectedLocation = [locations objectAtIndex:indexPath.row];
    NSLog(@"selectedLocation id %ld", (long)selectedLocation.id);
    NSLog(@"selectedLocation name %@", selectedLocation.name);
    
    [self.delegate didLocationSelect:selectedLocation];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)cancelTouch:(id)sender {
    [self.delegate didLocationSelectCancel];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
