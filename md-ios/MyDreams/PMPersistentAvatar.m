//
//  PMPersistentAvatar.m
//  MyDreams
//
//  Created by Иван Ушаков on 12.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPersistentAvatar.h"
#import "PMImage.h"

@implementation PMPersistentAvatar

- (instancetype)initWithImage:(PMImage *)image
{
    self = [super init];
    if (self) {
        self.small = image.small;
        self.preMedium = image.preMedium;
        self.medium = image.medium;
        self.large = image.large;
    }
    return self;
}

- (PMImage *)toImage
{
    PMImage *image = [[PMImage alloc] init];
    [image setValue:self.small forKey:PMSelectorString(small)];
    [image setValue:self.preMedium forKey:PMSelectorString(preMedium)];
    [image setValue:self.medium forKey:PMSelectorString(medium)];
    [image setValue:self.large forKey:PMSelectorString(large)];
    return image;
}

@end
