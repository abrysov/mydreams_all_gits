//
//  PMPostMapperImpl.h
//  MyDreams
//
//  Created by user on 29.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPostMapper.h"

@protocol PMLikeApiClient;
@protocol PMImageDownloader;

@interface PMPostMapperImpl : NSObject <PMPostMapper>
@property (strong, nonatomic) id<PMLikeApiClient> likeApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@end
