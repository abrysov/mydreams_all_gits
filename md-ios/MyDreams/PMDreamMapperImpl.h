//
//  PMDreamMapper.h
//  MyDreams
//
//  Created by user on 28.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamMapper.h"

@protocol PMLikeApiClient;
@protocol PMImageDownloader;

@interface PMDreamMapperImpl : NSObject <PMDreamMapper>
@property (strong, nonatomic) id<PMLikeApiClient> likeApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@end
