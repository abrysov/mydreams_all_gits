//
//  PMObjectMapperMulti.m
//  MyDreams
//
//  Created by Иван Ушаков on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMObjectMapperMulti.h"

@interface PMObjectMapperMulti ()
@property (strong, nonatomic) NSMutableDictionary *mappers;
@end

@implementation PMObjectMapperMulti

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mappers = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)registerMapper:(id<PMObjectMapper>)mapper forClass:(Class)responseClass
{
    [self.mappers setValue:mapper forKey:NSStringFromClass(responseClass)];
}

- (id<PMObjectMapper>)mapperForClass:(Class)responseClass
{
    __block id<PMObjectMapper> mapper = nil;
    [self.mappers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        Class responseClassForCurrentMapper = NSClassFromString(key);
        
        if ([responseClass isSubclassOfClass:responseClassForCurrentMapper]) {
            mapper = obj;
            *stop = YES;
        }
    }];
    
    return mapper;
}

- (RACSignal *)mapResponseObject:(id)respObj keyPath:(NSString *)keyPath toClass:(Class)responseClass;
{
    id<PMObjectMapper> mapper = [self mapperForClass:responseClass];
    
    if (mapper) {
        return [mapper mapResponseObject:respObj keyPath:keyPath toClass:responseClass];
    }
    
    return [RACSignal return:respObj];
}

@end
