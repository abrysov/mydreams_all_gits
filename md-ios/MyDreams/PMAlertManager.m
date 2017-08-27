//
//  PMAlertManager.m
//  MyDreams
//
//  Created by user on 29.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAlertManager.h"

@implementation PMAlertManager

- (void)showAlertWithError:(NSError *)error in:(UIViewController *)controller
{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"alert_manager.Error", nil)
                                                                   message:error.localizedDescription
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okButton = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert_manager.OK", nil)
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action)
                               {
                               }];
    [alert addAction:okButton];
    [controller presentViewController:alert animated:YES completion:nil];
}

- (void)processErrorsOfCommand:(RACCommand *)command in:(UIViewController *)controller
{
    @weakify(self);
    [command.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self showAlertWithError:error in:controller];
    }];
}

@end
