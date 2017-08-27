//
//  PMContriesResponse.h
//  MyDreams
//
//  Created by user on 04.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"
#import "PMLocation.h"

@interface PMCountriesResponse : PMBaseResponse
@property (strong, nonatomic, readonly) NSArray *countries;
@end
