//
//  PMBaseSocketResponse.m
//  MyDreams
//
//  Created by Иван Ушаков on 03.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseSocketResponse.h"

@interface PMBaseSocketResponse ()
@property (nonatomic, strong) NSDate *retrievedAt;
@property (nonatomic, assign) BOOL isFromOfflineCache;
@end

@implementation PMBaseSocketResponse

- (instancetype)initWithDictionary:(NSDictionary *)dictionaryValue error:(NSError **)error
{
    self = [super initWithDictionary:dictionaryValue error:error];
    if (self) {
        self.retrievedAt = [NSDate date];
    }
    
    return self;
}

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{};
}

@end
