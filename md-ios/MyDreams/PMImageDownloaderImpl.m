//
//  PMImageDownloaderImpl.m
//  MyDreams
//
//  Created by Иван Ушаков on 30.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMImageDownloaderImpl.h"
#import <AFNetworking/AFNetworking.h>
#import <DFImageManager/DFImageManagerKit.h>

@interface PMImageDownloaderImpl ()
@end

@implementation PMImageDownloaderImpl

- (instancetype)init
{
    self = [super init];
    if (self) {
        [DFImageManagerConfiguration setAllowsProgressiveImage:YES];
    }
    return self;
}

- (RACSignal *)imageForURL:(NSURL *)url
{
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

        DFMutableImageRequestOptions *options = [DFMutableImageRequestOptions new];
        options.allowsProgressiveImage = YES;
        
        DFImageTask *task = [DFImageManager imageTaskForResource:url completion:^(UIImage * _Nullable image, NSError * _Nullable error, DFImageResponse * _Nullable response, DFImageTask * _Nonnull imageTask) {
            if (image) {
                [subscriber sendNext:image];
                [subscriber sendCompleted];
            }
            else {
                [subscriber sendError:error];
            }
        }];
        [task resume];
        
        return [RACDisposable disposableWithBlock:^{
            [task cancel];
        }];
    }];
}


@end
