//
//  PMDreamerService.h
//  myDreams
//
//  Created by Ivan Ushakov on 24/03/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMDreamerFilterForm.h"
#import "PMPage.h"
#import "PMImageForm.h"

@protocol PMDreamerApiClient <NSObject>

- (RACSignal *)getDreamer:(NSNumber *)idx;
- (RACSignal *)getStatus;
- (RACSignal *)getPhotos:(NSNumber *)idx page:(PMPage *)page;
- (RACSignal *)removePhotos:(NSNumber *)idx;
- (RACSignal *)getDreamers:(PMDreamerFilterForm *)form page:(PMPage *)page;
@end
