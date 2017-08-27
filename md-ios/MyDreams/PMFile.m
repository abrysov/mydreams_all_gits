//
//  PMFile.m
//  MyDreams
//
//  Created by Иван Ушаков on 11.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFile.h"

@implementation PMFile

- (instancetype)initWithName:(NSString *)name data:(NSData *)data mimeType:(NSString *)mimeType
{
    self = [super init];
    if (self) {
        self.name = name;
        self.data = data;
        self.mimeType = mimeType;
    }
    return self;
}

@end
