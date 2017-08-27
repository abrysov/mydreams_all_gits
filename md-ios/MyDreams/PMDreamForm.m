//
//  PMDreamForm.m
//  MyDreams
//
//  Created by user on 12.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamForm.h"
#import "PMFile.h"
#import "PMDream.h"


@implementation PMDreamForm

- (instancetype)init
{
    self = [super init];
    if (self) {
        @weakify(self);
        
        self.isValidTitle = YES;
        self.isValidDescription = YES;
        self.isValidPhoto = YES;
        
        [[RACObserve(self, title)
          distinctUntilChanged]
          subscribeNext:^(id x) {
              @strongify(self);
              [self validateTitle];
          }];
        
        [[RACObserve(self, dreamDescription)
          distinctUntilChanged]
          subscribeNext:^(id x) {
              @strongify(self);
              [self validateDescription];
          }];
        
        [RACObserve(self, photo)
          subscribeNext:^(id x) {
              @strongify(self);
              [self validatePhoto];
          }];
    }
    return self;
}

- (instancetype)initWithDream:(PMDream *)dream
{
    self = [self init];
    if (self) {
        self.dreamIdx = dream.idx;
        self.title = dream.title;
        self.dreamDescription = dream.details;
        self.restrictionLevel = dream.restrictionLevel;
        self.photoURL = dream.image;
        self.isCameTrue = @(dream.fulfilled);
    }
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    [super JSONKeyPathsByPropertyKey];
    return @{
             PMSelectorString(title):@"title",
             PMSelectorString(dreamDescription):@"description",
             PMSelectorString(photo):@"photo",
             PMSelectorString(restrictionLevel):@"restriction_level",
             PMSelectorString(isCameTrue):@"came_true",
             PMSelectorString(cropRectX):@"photo_crop[x]",
             PMSelectorString(cropRectY):@"photo_crop[y]",
             PMSelectorString(cropRectWidth):@"photo_crop[width]",
             PMSelectorString(cropRectHeight):@"photo_crop[height]"
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

+ (NSValueTransformer *)photoJSONTransformer {
    return [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        if (!value) {
            return nil;
        }
        *success = YES;
        return [[PMFile alloc] initWithName:@"image.jpg" data:UIImageJPEGRepresentation(value, 0.8f) mimeType:@"image/jpeg"];
    }];
}

- (void)validateTitle
{
    self.isValidTitle = (self.title.length != 0);
}

- (void)validateDescription
{
    self.isValidDescription = (self.dreamDescription.length != 0);
}

- (void)validatePhoto
{
    self.isValidPhoto = (self.photo != nil);
}
@end
