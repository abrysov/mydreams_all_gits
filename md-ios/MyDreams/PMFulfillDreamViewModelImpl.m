
//
//  PMFulfillDreamViewModelImpl.m
//  MyDreams
//
//  Created by user on 19.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFulfillDreamViewModelImpl.h"

@interface PMFulfillDreamViewModelImpl ()
@property (nonatomic, strong) UIImage *photo;
@property (nonatomic, strong) NSString *dreamDescription;
@property (nonatomic, assign) BOOL restrictionLevelPrivate;
@property (nonatomic, assign) BOOL restrictionLevelFriends;
@property (nonatomic, assign) BOOL restrictionLevelPublic;
@end


@implementation PMFulfillDreamViewModelImpl

- (instancetype)initWithDreamForm:(PMDreamForm *)form
{
    self = [super init];
    if (self) {
        RAC(self,dreamDescription) = RACObserve(form, dreamDescription);
        RAC(self, photo) = RACObserve(form, photo);
        [RACObserve(form, restrictionLevel) subscribeNext:^(id input) {
            PMDreamRestrictionLevel level = [input integerValue];
            self.restrictionLevelPublic = (level == PMDreamRestrictionLevelPublic);
            self.restrictionLevelFriends = (level == PMDreamRestrictionLevelFriends);
            self.restrictionLevelPrivate = (level == PMDreamRestrictionLevelPrivate);
        }];
    }
    return self;
}

@end
