//
//  PMCredentialStore.h
//  MyDreams
//
//  Created by Иван Ушаков on 18.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMCredentialStore <NSObject>
- (void)storeCredential:(id<NSCoding>)credential withIdentifier:(NSString *)identifier;
- (void)deleteCredentialWithIdentifier:(NSString*)identifier;
- (id<NSCoding>)retrieveCredentialWithIdentifier:(NSString *)identifier;
@end
