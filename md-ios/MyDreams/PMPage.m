//
//  PMPage.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPage.h"

@interface PMPage ()
@property (nonatomic, strong) NSNumber *from;
@property (nonatomic, strong) NSNumber *per;
@property (nonatomic, strong) NSNumber *page;
@end

@implementation PMPage

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [super JSONKeyPathsByPropertyKey];
    return @{PMSelectorString(from): @"from",
             PMSelectorString(per): @"per",
             PMSelectorString(page): @"page",
             };
}

- (instancetype)initWithPage:(NSUInteger)page per:(NSUInteger)per
{
    self = [super init];
    if (self) {
        self.page = @(page);
        self.per = @(per);
    }
    
    return self;
}

- (void)updatePage:(NSInteger)page per:(NSInteger)per
{
    self.page = @(page);
    self.per = @(per);
}

@end
