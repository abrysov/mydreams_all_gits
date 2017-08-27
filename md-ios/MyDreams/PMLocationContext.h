//
//  PMLocationContext.h
//  MyDreams
//
//  Created by user on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseContext.h"

@interface PMLocationContext : PMBaseContext
@property (nonatomic, strong) RACSubject *localitySubject;
@property (nonatomic, strong) NSNumber *countryIdx;
+ (PMLocationContext *)contextWithSubject:(RACSubject *)localitySubject;
@end
