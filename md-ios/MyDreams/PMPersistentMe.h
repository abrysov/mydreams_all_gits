//
//  PMPersistentMe.h
//  MyDreams
//
//  Created by Иван Ушаков on 28.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBasePersistentModel.h"
#import "PMPersistentAvatar.h"

@class PMDreamer;
@class PMStatus;

@interface PMPersistentMe : RLMObject
@property (strong, nonatomic) NSNumber<RLMInt> *idx;
@property (strong, nonatomic) NSString *fullName;
@property (strong, nonatomic) NSString *gender;
@property (strong, nonatomic) NSNumber<RLMBool> *isVip;
@property (strong, nonatomic) NSNumber<RLMBool> *isCelebrity;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSNumber <RLMInt> *cityIdx;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSNumber <RLMInt> *countryIdx;
@property (strong, nonatomic) NSNumber<RLMInt> *visitsCount;
@property (strong, nonatomic) NSString *firstName;
@property (strong, nonatomic) NSString *lastName;
@property (strong, nonatomic) NSDate *birthday;
@property (strong, nonatomic) NSString *status;
@property (strong, nonatomic) NSNumber<RLMInt> *viewsCount;
@property (strong, nonatomic) NSNumber<RLMInt> *friendsCount;
@property (strong, nonatomic) NSNumber<RLMInt> *dreamsCount;
@property (strong, nonatomic) NSNumber<RLMInt> *fullfiledDreamsCount;
@property (strong, nonatomic) NSNumber<RLMBool> *isBlocked;
@property (strong, nonatomic) NSNumber<RLMBool> *isDeleted;
@property (strong, nonatomic) NSNumber<RLMInt> *launchesCount;
@property (strong, nonatomic) NSNumber<RLMBool> *isOnline;
@property (strong, nonatomic) PMPersistentAvatar *avatar;
@property (strong, nonatomic) NSString *token;

@property (strong, nonatomic) NSNumber<RLMInt> *coinsCount;
@property (strong, nonatomic) NSNumber<RLMInt> *messagesCount;
@property (strong, nonatomic) NSNumber<RLMInt> *notificationsCount;
@property (strong, nonatomic) NSNumber<RLMInt> *friendRequestsCount;

- (instancetype)initWithDreamer:(PMDreamer *)dreamer status:(PMStatus *)status;
- (PMDreamer *)toDreamer;
- (PMStatus *)toStatus;

@end
