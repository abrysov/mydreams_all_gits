//
//  PMLocalityViewModelImpl.m
//  MyDreams
//
//  Created by user on 07.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMLocalityViewModelImpl.h"

@interface PMLocalityViewModelImpl ()
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) NSString *descriptionLocality;
@end

@implementation PMLocalityViewModelImpl

- (instancetype)initWithLocality:(PMLocality *)locality
{
    self = [super init];
    if (self) {
        self.title = locality.name;
        self.descriptionLocality = locality.descriptionLocality;
    }
    return self;
}

@end
