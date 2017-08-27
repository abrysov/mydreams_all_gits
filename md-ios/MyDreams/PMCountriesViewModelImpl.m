//
//  PMCountriesViewModelimpl.m
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCountriesViewModelimpl.h"

@interface PMCountriesViewModelImpl ()
@property (nonatomic, strong) NSArray *countries;
@end

@implementation PMCountriesViewModelImpl

- (instancetype)initWithCountries:(NSArray *)countries
{
    self = [super init];
    if (self) {
        self.countries = countries;
    }
    return self;
}
@end
