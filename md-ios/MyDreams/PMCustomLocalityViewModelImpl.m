//
//  PMCustomLocalityViewModelImpl.m
//  MyDreams
//
//  Created by user on 13.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCustomLocalityViewModelImpl.h"

@interface PMCustomLocalityViewModelImpl ()
@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *region;
@property (strong, nonatomic) NSString *district;
@end

@implementation PMCustomLocalityViewModelImpl
- (instancetype)initWithLocalityForm:(PMLocalityForm *)localityForm
{
    self = [super init];
    if (self) {
        self.name = localityForm.name;
        self.region = localityForm.region;
        self.district = localityForm.district;
    }
    return self;
}
@end
