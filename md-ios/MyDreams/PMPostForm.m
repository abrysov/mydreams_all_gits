//
//  PMPostForm.m
//  MyDreams
//
//  Created by user on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostForm.h"
#import "PMPost.h"

@implementation PMPostForm

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        
        self.isValidDescription = YES;
        
        [[RACObserve(self, content)
            distinctUntilChanged]
            subscribeNext:^(id x) {
                @strongify(self);
                [self validateDescription];
            }];
    }
    return self;
}

- (instancetype)initWithPost:(PMPost *)post
{
    self = [self init];
    if (self) {
        self.postIdx = post.idx;
        self.content = post.content;
        self.restrictionLevel = post.restrictionLevel;
        self.postPhotos = post.photos;
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [super JSONKeyPathsByPropertyKey];
    return @{PMSelectorString(restrictionLevel): @"restriction_level",
             PMSelectorString(content): @"content",
             PMSelectorString(postPhotosIdxs):@"post_photos_ids",
             };
}

+ (NSValueTransformer *)restrictionLevelJSONTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{
                                                                           @"private": @(PMDreamRestrictionLevelPrivate),
                                                                           @"public": @(PMDreamRestrictionLevelPublic),
                                                                           @"friends": @(PMDreamRestrictionLevelFriends),
                                                                           } defaultValue:PMDreamRestrictionLevelPublic reverseDefaultValue:[NSNull null]];
}

- (void)validateDescription
{
    self.isValidDescription = (self.content.length != 0);
}

@end
