//
//  PMCredentialStoreImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 18.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCredentialStoreImpl.h"
#import <SimpleKeychain/SimpleKeychain.h>

@interface PMCredentialStoreImpl ()
@property (strong, nonatomic) A0SimpleKeychain *keychain;
@end

@implementation PMCredentialStoreImpl

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.keychain = [A0SimpleKeychain keychain];
    }
    return self;
}

- (void)storeCredential:(id<NSCoding>)credential withIdentifier:(NSString *)identifier
{
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:credential];
    [self.keychain setData:data forKey:identifier];
}

- (void)deleteCredentialWithIdentifier:(NSString*)identifier
{
    [self.keychain deleteEntryForKey:identifier];
}

- (id<NSCoding>)retrieveCredentialWithIdentifier:(NSString *)identifier
{
    NSData *data = [self.keychain dataForKey:identifier];
    return [NSKeyedUnarchiver unarchiveObjectWithData:data];
}

@end
