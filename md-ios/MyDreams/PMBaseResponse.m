//
//  PMBaseResponse.m
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"

@interface PMBaseResponse ()
@property (nonatomic, strong) PMResponseMeta *meta;
@property (nonatomic, strong) NSDate *retrievedAt;
@property (nonatomic, assign) BOOL isFromOfflineCache;
@end

@implementation PMBaseResponse

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
    return @{PMSelectorString(meta): @"meta"};
}

+ (NSValueTransformer *)metaJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMResponseMeta class]];
}

@end
