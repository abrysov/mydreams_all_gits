//
//  PMCommentsApiClient.h
//  MyDreams
//
//  Created by Иван Ушаков on 19.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMEntityType.h"

@class PMPage;

@protocol PMCommentsApiClient <NSObject>
@property (strong, nonatomic) RACSignal *comments;
@property (strong, nonatomic) RACSignal *reactions;

- (RACSignal *)requestCommentsListForResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx page:(PMPage *)page;
- (void)subscribeToCommentsForResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx;
- (void)unsubscribeFromCommentsForResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx;
- (void)postComment:(NSString *)message forResourceType:(PMEntityType)resourceType resourceIdx:(NSNumber *)resourceIdx;
- (void)addReaction:(NSString *)reaction forCommentWithIdx:(NSNumber *)commentIdx;
@end
