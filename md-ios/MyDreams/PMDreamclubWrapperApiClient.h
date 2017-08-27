//
//  PMDreamclubWrapperApiClient.h
//  MyDreams
//
//  Created by user on 10.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@class PMPage;

@protocol PMDreamclubWrapperApiClient <NSObject>
- (RACSignal *)getDreamclub;
- (RACSignal *)getDreamclubFeeds:(PMPage *)page;
@end
