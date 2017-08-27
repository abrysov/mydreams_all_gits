//
//  PMRemaindPasswordLogic.m
//  MyDreams
//
//  Created by Иван Ушаков on 03.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMRemaindPasswordLogic.h"
#import "PMAuthService.h"
#import "AuthentificationSegues.h"
#import "PMSuccessSendingEmailContext.h"

NSString * const PMRemaindPasswordLogicErrorDomain = @"com.mydreams.remaind_password.logic.error";

@interface PMRemaindPasswordLogic ()
@property (nonatomic, strong) RACChannelTerminal *emailTerminal;
@property (nonatomic, strong) RACCommand *sendEmailCommand;
@property (nonatomic, strong) RACCommand *backCommand;

@property (assign, nonatomic) BOOL isValidInput;
@property (assign, nonatomic) BOOL isValidEmail;

@property (strong, nonatomic) NSString *email;
@end

@implementation PMRemaindPasswordLogic

- (void)startLogic
{
    [super startLogic];

    self.isValidEmail = YES;
    self.isValidInput = YES;

    self.emailTerminal = RACChannelTo(self, email);
    self.sendEmailCommand = [self createSendEmailCommand];
    self.backCommand = [self createBackCommand];
    
    @weakify(self);
    [RACObserve(self, email) subscribeNext:^(id x) {
        @strongify(self);
        [self validateEmail];
    }];
}

#pragma mark - private

- (RACCommand *)createSendEmailCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self validate];
        
        RACSignal *signal = nil;
        
        if (self.isValidInput) {
            signal = [self.authService remaindPasswordWithEmail:self.email];
        }
        else {
            NSError *error = [NSError errorWithDomain:PMRemaindPasswordLogicErrorDomain
                                                 code:PMRemaindPasswordLogicErrorInvalidInput
                                             userInfo:@{NSLocalizedDescriptionKey:NSLocalizedString(@"error.invalidInput", nil)}];
            signal = [RACSignal error:error];
        }
        
        return [[signal
            doNext:^(id x) {
                @strongify(self);
                PMSuccessSendingEmailContext *context = [PMSuccessSendingEmailContext contextWithEmail:self.email];
                [self performSegueWithIdentifier:kPMSegueIdentifierToSuccessSendingEmailVCFromRemaindPasswordVC context:context];
            }]
            doError:^(NSError *error) {
                @strongify(self);
                [self setInputInvalid];
            }];
    }];
}

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseRemindPasswordVC];
        return [RACSignal empty];
    }];
}

- (void)validate
{
    [self validateEmail];
}

- (void)validateEmail
{
    BOOL hasSymbols = YES;
    
    NSArray *arraySymbolsForValidating = @[@"@", @"."];
    for (NSString *symbol in arraySymbolsForValidating) {
        if ([self.email rangeOfString:symbol].location == NSNotFound) {
            hasSymbols =  NO;
        }
    }
    
    self.isValidEmail = (self.email.length > 0) && hasSymbols;
    self.isValidInput = self.isValidEmail;
}

- (void)setInputInvalid
{
    self.isValidEmail = NO;
    self.isValidInput = NO;
}

@end
