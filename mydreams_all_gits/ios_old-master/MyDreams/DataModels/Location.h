//
//  Location.h
//  MyDreams
//
//  Created by Игорь on 12.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonResponseModel.h"

@protocol Location
@end

@interface Location : JSONModel
@property (assign, nonatomic) NSInteger id;
@property (retain, nonatomic) NSString *name;
@property (retain, nonatomic) NSString<Optional> *parent;
@end

@interface FindLocationsResponseModel : CommonResponseModel
@property NSArray <Location, Optional> *locations;
@end

@interface CountriesResponseModel : CommonResponseModel
@property NSArray <Location, Optional> *countries;
@end