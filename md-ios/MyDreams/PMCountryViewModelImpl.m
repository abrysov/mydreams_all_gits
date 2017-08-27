//
//  PMCountyViewModelImpl.m
//  MyDreams
//
//  Created by user on 06.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCountryViewModelImpl.h"
@interface PMCountryViewModelImpl ()
@property (strong, nonatomic) NSString *title;
@end

@implementation PMCountryViewModelImpl

- (instancetype)initWithCountry:(PMLocation *)country
{
    self = [super init];
    if (self) {
        self.title = country.name;
    }
    return self;
}

@end
