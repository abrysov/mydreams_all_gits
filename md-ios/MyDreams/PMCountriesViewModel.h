//
//  PMCountriesViewModel.h
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocation.h"

@protocol PMCountriesViewModel <NSObject>
@property (strong, nonatomic, readonly) NSArray *countries;
@end
