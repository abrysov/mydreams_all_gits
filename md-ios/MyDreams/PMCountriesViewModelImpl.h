//
//  PMCountriesViewModelimpl.h
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMCountriesViewModel.h"

@interface PMCountriesViewModelImpl : NSObject <PMCountriesViewModel>
- (instancetype)initWithCountries:(NSArray *)countries;
@end
