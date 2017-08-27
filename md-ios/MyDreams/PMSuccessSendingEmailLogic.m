//
//  PMSuccessRemaindPasswordLogic.m
//  MyDreams
//
//  Created by user on 11.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSuccessSendingEmailLogic.h"
#import "AuthentificationSegues.h"
#import "PMSuccessSendingEmailContext.h"

@interface PMSuccessSendingEmailLogic ()
@property (strong, nonatomic) PMSuccessSendingEmailContext *context;

@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) RACCommand *doneCommand;
@property (strong, nonatomic) RACCommand *resendCommand;
@end

@implementation PMSuccessSendingEmailLogic
@dynamic context;

- (void)startLogic
{
    [super startLogic];

    self.email = self.context.email;
    self.doneCommand = [self createDoneCommand];
    self.resendCommand = [self createResendCommand];
}

#pragma mark - private


- (RACCommand *)createDoneCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierToAuthorizationVC];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createResendCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseSuccessSendingEmailVC];
        return [RACSignal empty];
    }];
}

@end
