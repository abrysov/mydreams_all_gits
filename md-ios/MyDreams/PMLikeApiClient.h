//
//  PMApiLike.h
//  MyDreams
//
//  Created by user on 22.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEntityType.h"

@class PMPage;

@protocol PMLikeApiClient <NSObject>
- (RACSignal *)createLikeWithIdx:(NSNumber *)idx entityType:(PMEntityType)type;
- (RACSignal *)removeLikeWithIdx:(NSNumber *)idx entityType:(PMEntityType)type;
- (RACSignal *)getDreamersWhoLikedEntityWithIdx:(NSNumber *)idx entityType:(PMEntityType)type page:(PMPage *)page;
@end