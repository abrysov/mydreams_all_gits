//
//  PMDreamApiClient.h
//  MyDreams
//
//  Created by Иван Ушаков on 26.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PMDreamFilterForm;
@class PMPage;
@class PMDreamForm;

@protocol PMDreamApiClient <NSObject>

- (RACSignal *)getDream:(NSNumber *)idx;
- (RACSignal *)updateDream:(PMDreamForm *)form progress:(RACSubject *)progress;
- (RACSignal *)removeDream:(NSNumber *)idx;
- (RACSignal *)getDreams:(PMDreamFilterForm *)form page:(PMPage *)page;
- (RACSignal *)getOwnDreams:(PMDreamFilterForm *)form page:(PMPage *)page;
- (RACSignal *)getTopDreams:(PMPage *)page;
- (RACSignal *)createDream:(PMDreamForm *)form progress:(RACSubject *)progress;
- (RACSignal *)getDreamsOfDreamer:(NSNumber *)index form:(PMDreamFilterForm *)form page:(PMPage *)page;
@end
