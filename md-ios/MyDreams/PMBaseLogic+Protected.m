//
//  PMBaseLogic+Protected.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic+Protected.h"

NSString * const PMBaseLogicErrorDomain = @"com.mydreams.base.logic.error";

@implementation PMBaseLogic (Protected)
@dynamic isDataLoaded;

- (void)performSegueWithIdentifier:(NSString *)segue context:(id)context
{
    [self.performedSegues sendNext:RACTuplePack(segue, context)];
}

- (void)performSegueWithIdentifier:(NSString *)segue
{
    [self performSegueWithIdentifier:segue context:nil];
}

- (RACSignal *)openURL:(NSURL *)url
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        if ([[UIApplication sharedApplication] canOpenURL:url]) {
            [subscriber sendNext:@YES];
            [subscriber sendCompleted];
            [[UIApplication sharedApplication] openURL:url];
        }
        else {
            NSError *error = [NSError errorWithDomain:PMBaseLogicErrorDomain code:PMBaseLogicErrorCannotOpenUrl userInfo:@{}];
            [subscriber sendError:error];
        }
        
        return [RACDisposable disposableWithBlock:^{}];
    }];
}

- (RACCommand *)createRouteCommandWithSegueIdentifier:(NSString *)segueIdentifier
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self performSegueWithIdentifier:segueIdentifier];
        return [RACSignal empty];
    }];
}

@end
