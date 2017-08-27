//
//  TopDreamCell.m
//  MyDreams
//
//  Created by Игорь on 16.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "ProposedDreamCell.h"
#import "ApiDataManager.h"
#import "Helper.h"

@implementation ProposedDreamCell {
    NSInteger dreamId;
}

- (void)initUIWith:(Dream *)dream andAppearence:(AppearenceStyle)appearence {
    dreamId = dream.id;
    [super initUIWith:dream andAppearence:appearence];
}

- (IBAction)acceptTouch:(id)sender {
    [ApiDataManager acceptproposed:dreamId success:^{
        [self showAlert:@"_PROPOSED_ACCEPTED"];
        [self.deleteCellDelegate deleteCell:self];
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (IBAction)rejectTouch:(id)sender {
    [ApiDataManager rejectproposed:dreamId success:^{
        [self showAlert:@"_PROPOSED_REJECTED"];
        [self.deleteCellDelegate deleteCell:self];
    } error:^(NSString *error) {
        [self showAlert:error];
    }];
}

- (void)showAlert:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:[Helper localizedStringIfIsCode:title]
                                message:nil
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

@end
