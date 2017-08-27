//
//  PMDreamersViewModelImpl.m
//  MyDreams
//
//  Created by user on 05.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamersViewModelImpl.h"
#import "PMDreamerViewModelImpl.h"

@interface PMDreamersViewModelImpl ()
@property (nonatomic, strong) NSString *filtersDescription;
@property (strong, nonatomic) NSString *totalResult;
@end

@implementation PMDreamersViewModelImpl

- (instancetype)initWithFilterForm:(PMDreamerFilterForm *)filterForm
{
    if (self = [super init]) {
        NSString *generalString = @"";
        
        if (filterForm.gender == PMDreamerGenderFemale) {
            NSString *value = NSLocalizedString(@"dreambook.filters_dreamers.gender_woman",nil);
            generalString = [NSString stringWithFormat:@"%@ %@,", generalString, value];
        } else if (filterForm.gender == PMDreamerGenderMale) {
            NSString *value = NSLocalizedString(@"dreambook.filters_dreamers.gender_man",nil);
            generalString = [NSString stringWithFormat:@"%@ %@,", generalString, value];
        }
        
        if (filterForm.ageFrom && ![filterForm.ageFrom isEqual:@""]) {
            NSString *value = [NSLocalizedString(@"dreambook.filters_dreamers.from_age_placeholder",nil) lowercaseString];
            if (filterForm.ageTo && ![filterForm.ageTo isEqual:@""])
                generalString = [NSString stringWithFormat:@"%@ %@ %@", generalString, value, filterForm.ageFrom];
            else
                generalString = [NSString stringWithFormat:@"%@ %@ %@,", generalString, value, filterForm.ageFrom];
        }
        
        if (filterForm.ageTo && ![filterForm.ageTo isEqual:@""]) {
            NSString *value = [NSLocalizedString(@"dreambook.filters_dreamers.before_age_placeholder",nil) lowercaseString];
            generalString = [NSString stringWithFormat:@"%@ %@ %@,", generalString, value, filterForm.ageTo];
        }
        
        if (filterForm.country) {
            generalString = [NSString stringWithFormat:@"%@ %@,", generalString, filterForm.country];
        }
        
        if (filterForm.city) {
            generalString = [NSString stringWithFormat:@"%@ %@,", generalString, filterForm.city];
        }
        
        if ([filterForm.isNew boolValue]) {
            NSString *value = NSLocalizedString(@"dreambook.filters_dreamers.description_new_dreamers",nil);
            generalString = [NSString stringWithFormat:@"%@ %@,", generalString, value];
        }
        
        if ([filterForm.isTop boolValue]) {
            NSString *value = NSLocalizedString(@"dreambook.filters_dreamers.description_popular_dreamers",nil);
            generalString = [NSString stringWithFormat:@"%@ %@,", generalString, value];
        }
        
        if ([filterForm.isVip boolValue]) {
            NSString *value = NSLocalizedString(@"dreambook.filters_dreamers.description_vip_dreamers",nil);
            generalString = [NSString stringWithFormat:@"%@ %@,", generalString, value];
        }
        
        if ([filterForm.isOnline boolValue]) {
            NSString *value = NSLocalizedString(@"dreambook.filters_dreamers.description_online_dreamers",nil);
            generalString = [NSString stringWithFormat:@"%@ %@,", generalString, value];
        }
        
        if (![generalString isEqual:@""]) {
            self.filtersDescription = [generalString substringWithRange:NSMakeRange(0, generalString.length - 1)];
        }
    }
    return self;
}

- (void)updateTotalCount:(NSNumber *)totalCount
{
    NSString *found = NSLocalizedString(@"dreambook.list_dreamers.found_description", nil);
    NSString *dreamers = NSLocalizedString(@"dreambook.list_dreamers.dreamers_description", nil);
    
    NSString *formateString = [NSString stringWithFormat:@"%@ %@ %@", found, totalCount, dreamers];
    self.totalResult = formateString;
}

@end
