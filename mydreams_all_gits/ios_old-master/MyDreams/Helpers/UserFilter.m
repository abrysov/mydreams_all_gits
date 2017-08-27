//
//  UserFilter.m
//  MyDreams
//
//  Created by Игорь on 17.10.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import "UserFilter.h"

@implementation UserFilter
- (NSString *)description {
    return [NSString stringWithFormat:@"country:%ld\n city:%ld\n age:%@\n sex:%@\n popular:%d\n online:%d\n vip:%d\n isnew:%d\n", self.country, self.city, self.age, self.sex, self.popular, self.online, self.vip, self.isnew];
}
@end
