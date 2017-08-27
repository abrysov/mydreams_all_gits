//
//  PMFiltersDreamersViewModelImpl.m
//  MyDreams
//
//  Created by user on 06.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFiltersDreamersViewModelImpl.h"

@interface PMFiltersDreamersViewModelImpl ()
@property (strong, nonatomic) NSString *nameCountry;
@property (strong, nonatomic) NSString *nameCity;
@property (strong, nonatomic) NSString *totalResult;
@property (assign, nonatomic) NSInteger totalCount;
@property (assign, nonatomic) BOOL notFound;
@property (assign, nonatomic) BOOL isNew;
@property (assign, nonatomic) BOOL isPopular;
@property (assign, nonatomic) BOOL isVip;
@property (assign, nonatomic) BOOL isOnline;
@end

@implementation PMFiltersDreamersViewModelImpl

- (instancetype)initWithFilterForm:(PMDreamerFilterForm *)filterForm
{
    if (self = [super init]) {
        
        RAC(self, nameCountry) = [RACObserve(filterForm, country) map:^id(NSString *value) {
            if (value) {
                return value;
            } else {
                return NSLocalizedString(@"dreambook.filters_dreamers.country_not_selected", nil);
            }
        }];
        
        RAC(self, nameCity) = [RACObserve(filterForm, city) map:^id(NSString *value) {
            if (value) {
                return value;
            } else {
                return NSLocalizedString(@"dreambook.filters_dreamers.city_not_selected", nil);
            }
        }];
        
        RAC(self, isNew) = [self mapSignalToBool:RACObserve(filterForm, isNew)];
        RAC(self, isPopular) = [self mapSignalToBool:RACObserve(filterForm, isTop)];
        RAC(self, isVip) = [self mapSignalToBool:RACObserve(filterForm, isVip)];
        RAC(self, isOnline) = [self mapSignalToBool:RACObserve(filterForm, isOnline)];
        
        RAC(self, totalResult) = [RACObserve(self, totalCount) map:^id(NSNumber *value) {
            NSString *show = NSLocalizedString(@"dreambook.filters_dreamers.send_button_title_show", nil);
            NSString *results = NSLocalizedString(@"dreambook.filters_dreamers.send_button_title_results", nil);
            
            NSString *formateString = [NSString stringWithFormat:@"%@ %@ %@", show, value, results];
            return [NSString stringWithFormat:@"%@",formateString];
        }];
    }
    return self;
}

- (void)updateTotalCount:(NSInteger)totalCount
{
    self.totalCount = totalCount;
    self.notFound = NO;
}

- (void)receiveNotFound
{
    self.notFound = YES;
}

#pragma makr - private

- (RACSignal *)mapSignalToBool:(RACSignal *)signal
{
    return [signal map:^id(NSNumber *value) {
        return @([value boolValue]);
    }];
}

@end
