//
//  PMBasePersistentModel.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Realm/Realm.h>

@interface PMBasePersistentModel : RLMObject
@property (nonatomic, strong) NSNumber<RLMInt> *idx;
@property (nonatomic, strong) NSDate *retrievedAt;

- (BOOL)isPersisted;

@end
