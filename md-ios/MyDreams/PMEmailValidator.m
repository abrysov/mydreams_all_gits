//
//  PMEmailValidator.m
//  MyDreams
//
//  Created by user on 01.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEmailValidator.h"

@implementation PMEmailValidator

- (BOOL)isEmailValid:(NSString*)email
{
    return (email.length > 0) && (email.length < 255) && [self checkEMailOnSymbols:email];
}

#pragma mark - private

- (BOOL)checkEMailOnSymbols:(NSString *)email
{
    NSArray *arraySymbolsForValidating = @[@"@", @"."];
    for (NSString *symbol in arraySymbolsForValidating) {
        if ([email rangeOfString:symbol].location == NSNotFound) {
            return NO;
        }
    }
    return YES;
}

@end
