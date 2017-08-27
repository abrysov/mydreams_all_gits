//
//  PMPaginationResponse.m
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"
#import "PMPaginationResponseMeta.h"

@interface PMPaginationResponse ()
@property (nonatomic, strong) PMPaginationResponseMeta *meta;
@property (nonatomic, strong) NSDate *retrievedAt;
@property (nonatomic, assign) BOOL isFromOfflineCache;
@end

@implementation PMPaginationResponse

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
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[PMPaginationResponseMeta class]];
}

@end
