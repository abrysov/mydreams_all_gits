//
//  PMBlockedProfileLogic.m
//  MyDreams
//
//  Created by user on 11.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBlockedProfileLogic.h"
#import "AuthentificationSegues.h"

@interface PMBlockedProfileLogic ()
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *openEmailCommand;
@end

@implementation PMBlockedProfileLogic

- (void)startLogic
{
    [super startLogic];
    self.backCommand = [self createBackCommand];
    self.openEmailCommand = [self createOpenEmailCommand];
}

#pragma mark - priavte

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseBlockedProfileVC];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createOpenEmailCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        
        NSString *email = [self.supportEmail stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSString *stringUrl = [NSString stringWithFormat:@"mailto:%@", email];
        NSURL *url = [NSURL URLWithString:stringUrl];
        
        return [self openURL: url];
    }];
}

@end
