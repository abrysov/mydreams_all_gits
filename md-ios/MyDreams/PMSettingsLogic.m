//
//  PMSettingsLogic.m
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSettingsLogic.h"
#import "PMBaseLogic+Protected.h"
#import "PMSettingsSegues.h"
#import "SettingsSegues.h"
#import "PMAuthService.h"
#import "PMProfileApiClient.h"

@interface PMSettingsLogic ()
@property (strong, nonatomic) RACCommand *signOutCommand;
@property (strong, nonatomic) RACCommand *toChangePasswordCommand;
@property (strong, nonatomic) RACCommand *toChangeEmailCommand;
@property (strong, nonatomic) RACCommand *toEditProfileCommand;
@property (strong, nonatomic) RACCommand *accountDeletingCommand;
@end

@implementation PMSettingsLogic

- (void)startLogic
{
    [super startLogic];
    self.signOutCommand = [self createSignOutCommand];
    self.toChangePasswordCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierToChangePasswordVC];
    self.toChangeEmailCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierToChangeEmailVC];
    self.toEditProfileCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierToEditProfileVC];
    self.accountDeletingCommand = [self createAccountDeletingCommand];
}

- (RACCommand *)createSignOutCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self signOut];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createAccountDeletingCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        return [[self.profileApiClient accountDeleting] doNext:^(id x) {
            @strongify(self);
            [self signOut];
        }];
    }];
}

#pragma mark - private

- (void)signOut
{
    [self.authService logout];
    [self performSegueWithIdentifier:kPMSegueIdentifierSettingsToAuthorizationVC];
}

@end
