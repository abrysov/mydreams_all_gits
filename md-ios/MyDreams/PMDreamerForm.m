//
//  PMDreamerForm.m
//  MyDreams
//
//  Created by user on 06.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerForm.h"
#import "PMFile.h"
#import "PMDreamer.h"

@implementation PMDreamerForm

- (instancetype)initWithDreamer:(PMDreamer *)dreamer
{
    self = [super init];
    if (self) {
        self.firstName = dreamer.firstName;
        self.secondName = dreamer.lastName;
        self.birthday = dreamer.birthday;
        self.sex = dreamer.gender;
        self.country = [[PMLocation alloc] init];
        self.locality = [[PMLocality alloc] init];
        self.country = dreamer.country;
        self.locality = (PMLocality *)dreamer.city;
        self.avatarURL = dreamer.avatar;
        
        [self setup];
    }
    return self;
}

#pragma mark - json

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [super JSONKeyPathsByPropertyKey];
    NSDictionary *mapping = @{
                              PMSelectorString(firstName): @"first_name",
                              PMSelectorString(secondName): @"last_name",
                              PMSelectorString(sex): @"gender",
                              PMSelectorString(birthday): @"birthday",
                              PMSelectorString(country): @"country_id",
                              PMSelectorString(locality): @"city_id",
                              PMSelectorString(avatar): @"avatar"
                              };
    
    return mapping;
}

+ (NSValueTransformer *)avatarJSONTransformer {
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if (!value) {
            return nil;
        }
        *success = YES;
        return [[PMFile alloc] initWithName:@"image.jpg" data:UIImageJPEGRepresentation(value, 0.8f) mimeType:@"image/jpeg"];
    }];
}

#pragma mark - private

- (void)setup
{
    @weakify(self);

    self.isValidFirstName = YES;
    self.isValidSecondName = YES;

    [[RACObserve(self, firstName)
        distinctUntilChanged]
        subscribeNext:^(id x) {
            @strongify(self);
            [self validateFirstName];
        }];
    
    [[RACObserve(self, secondName)
        distinctUntilChanged]
        subscribeNext:^(id x) {
            @strongify(self);
            self.isValidSecondName = YES;
        }];
}
@end
