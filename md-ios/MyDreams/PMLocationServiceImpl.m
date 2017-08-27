//
//  PMLocationServiceImpl.m
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocationServiceImpl.h"
#import "PMCountriesResponse.h"
#import "PMLocalitiesResponse.h"
#import "PMCustomLocalityResponse.h"

@implementation PMLocationServiceImpl

- (RACSignal *)countriesListWithSearchTerm:(NSString *)term
{
    NSDictionary *parameters = nil;
    if ((term) && (![term isEqualToString:@""])) {
        parameters = @{@"q":term};
    }
    
    return [self.apiClient requestPath:@"countries"
                            parameters:parameters
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMCountriesResponse class]];
}

- (RACSignal *)countriesList
{
    return [self countriesListWithSearchTerm:nil];
}

- (RACSignal *)localitiesListCountry:(NSNumber *)index searchTerm:(NSString *)term
{
    NSDictionary *parameters = nil;
    if ((term) && (![term isEqualToString:@""])) {
        parameters = @{@"q":term};
    }
    
    NSString *requestPath = [NSString stringWithFormat:@"countries/%@/cities", index];
    
    return [self.apiClient requestPath:requestPath
                            parameters:parameters
                                method:PMAPIClientHTTPMethodGET
                    mapResponseToClass:[PMLocalitiesResponse class]];
}

- (RACSignal *)localitiesListCountry:(NSNumber *)index
{
    return [self localitiesListCountry:index searchTerm:nil];
}

- (RACSignal *)createLocalityInfo:(PMLocalityForm *)localityForm inCountry:(NSNumber *)index
{
    NSMutableDictionary *parameters = [[NSMutableDictionary alloc] init];
    [parameters setValue:localityForm.name forKey:@"city_name"];

    if (localityForm.region) {
        [parameters setValue:localityForm.region forKey:@"region_name"];
    }
    if (localityForm.district) {
        [parameters setValue:localityForm.district forKey:@"district_name"];
    }
    NSString *requestPath = [NSString stringWithFormat:@"countries/%@/cities", index];
    return [self.apiClient requestPath:requestPath
                            parameters:parameters
                                method:PMAPIClientHTTPMethodPOST
                    mapResponseToClass:[PMCustomLocalityResponse class]];
}

@end
