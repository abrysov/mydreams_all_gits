//
//  PMPhotoMapperImpl.h
//  MyDreams
//
//  Created by user on 29.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPhotoMapper.h"

@protocol PMImageDownloader;

@interface PMPhotoMapperImpl : NSObject <PMPhotoMapper>
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@end
