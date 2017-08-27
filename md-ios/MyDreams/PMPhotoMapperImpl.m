//
//  PMPhotoMapperImpl.m
//  MyDreams
//
//  Created by user on 29.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPhotoMapperImpl.h"
#import "PMPhoto.h"
#import "PMPhotoViewModelImpl.h"
#import "PMImageDownloader.h"

@implementation PMPhotoMapperImpl

- (NSArray *)photosToViewModels:(NSArray *)photos
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:photos.count];
    for (PMPhoto *photo in photos) {
        NSURL *imageUrl = [NSURL URLWithString:photo.photo];
        if (imageUrl) {
            PMPhotoViewModelImpl *photoViewModel = [[PMPhotoViewModelImpl alloc] init];
            photoViewModel.imageSignal = [self.imageDownloader imageForURL:imageUrl];
            photoViewModel.url = imageUrl;
            [viewModels addObject:photoViewModel];
        }
    }
    return [NSArray arrayWithArray:viewModels];
}

@end
