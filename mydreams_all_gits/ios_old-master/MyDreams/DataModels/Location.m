//
//  Location.m
//  MyDreams
//
//  Created by Игорь on 12.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "Location.h"
#import "CommonResponseModel.h"

@implementation Location
@end

@implementation FindLocationsResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.locations": @"locations"
                                                       }];
}
@end

@implementation CountriesResponseModel
+ (JSONKeyMapper *)keyMapper {
    return [[JSONKeyMapper alloc] initWithDictionary:@{
                                                       @"body.countries": @"countries"
                                                       }];
}
@end