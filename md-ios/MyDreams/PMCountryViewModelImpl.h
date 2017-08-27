//
//  PMCountyViewModelImpl.h
//  MyDreams
//
//  Created by user on 06.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMCountryViewModel.h"
#import "PMLocation.h"

@interface PMCountryViewModelImpl : NSObject <PMCountryViewModel>
- (instancetype)initWithCountry:(PMLocation *)country;
@end

