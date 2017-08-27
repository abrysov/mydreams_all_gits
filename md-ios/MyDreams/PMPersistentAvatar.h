//
//  PMPersistentAvatar.h
//  MyDreams
//
//  Created by Иван Ушаков on 12.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Realm/Realm.h>

@class PMImage;

@interface PMPersistentAvatar : RLMObject
@property (strong, nonatomic) NSString *small;
@property (strong, nonatomic) NSString *preMedium;
@property (strong, nonatomic) NSString *medium;
@property (strong, nonatomic) NSString *large;

- (instancetype)initWithImage:(PMImage *)image;
- (PMImage *)toImage;

@end
