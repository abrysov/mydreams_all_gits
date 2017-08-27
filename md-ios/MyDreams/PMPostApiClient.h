//
//  PMPostApiClient.h
//  MyDreams
//
//  Created by user on 03.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPage.h"
#import "PMSourceType.h"

@class PMPostForm;

@protocol PMPostApiClient <NSObject>
- (RACSignal *)getFeeds:(PMPage *)page;
- (RACSignal *)getPostsWithSearch:(NSString *)search page:(PMPage *)page;
- (RACSignal *)getFeedsWithDreamer:(NSNumber *)idx page:(PMPage *)page;

- (RACSignal *)createPost:(PMPostForm *)form;
- (RACSignal *)getPost:(NSNumber *)idx;
- (RACSignal *)updatePost:(PMPostForm *)form;
- (RACSignal *)removePost:(NSNumber *)idx;

- (RACSignal *)postPhotos:(UIImage *)photo idx:(NSNumber *)idx progress:(RACSubject *)progress;
- (RACSignal *)removePhotos:(NSNumber *)idx;

- (RACSignal *)getFeedComments:(PMSourceType)sourceType page:(PMPage *)page;
- (RACSignal *)getFeedRecommendations:(PMSourceType)sourceType page:(PMPage *)page;
@end
