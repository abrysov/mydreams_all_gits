//
//  PMLocationService.h
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocalityForm.h"

@protocol PMLocationService <NSObject>
- (RACSignal *)countriesList;
- (RACSignal *)countriesListWithSearchTerm:(NSString *)term;
- (RACSignal *)createLocalityInfo:(PMLocalityForm *)localityForm inCountry:(NSNumber *)index;
- (RACSignal *)localitiesListCountry:(NSNumber *)index searchTerm:(NSString *)term;
- (RACSignal *)localitiesListCountry:(NSNumber *)index;
@end