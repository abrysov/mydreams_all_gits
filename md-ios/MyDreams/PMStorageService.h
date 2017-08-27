//
//  PMStorageService.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Realm/Realm.h>

@protocol PMStorageService <NSObject>
@property (nonatomic, strong) RLMRealm *storage;
@end
