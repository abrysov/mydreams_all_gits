//
//  PMRestoreProfileLogic.m
//  MyDreams
//
//  Created by user on 14.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRestoreProfileLogic.h"
#import "PMAuthService.h"
#import "AuthentificationSegues.h"
#import "PMSuccessSendingEmailContext.h"

NSString * const PMRestoreProfileLogicErrorDomain = @"com.mydreams.restore_profile.logic.error";

@interface PMRestoreProfileLogic ()
@property (nonatomic, strong) RACCommand *sendEmailCommand;
@property (nonatomic, strong) RACCommand *backCommand;
@end

@implementation PMRestoreProfileLogic

- (void)startLogic
{
    [super startLogic];
    self.sendEmailCommand = [self createSendEmailCommand];
    self.backCommand = [self createBackCommand];
}

#pragma mark - private

- (RACCommand *)createSendEmailCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self.authService restoreProfile]
            doNext:^(id x) {
                @strongify(self);
                [self performSegueWithIdentifier:kPMSegueIdentifierToSuccessSendingEmailVCFromRestoreProfileVC];
            }];
    }];
}
   
- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseRestoreProfileVC];
        return [RACSignal empty];
    }];
}

@end