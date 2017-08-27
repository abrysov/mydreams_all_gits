//
//  PMDreamerMapperImpl.h
//  MyDreams
//
//  Created by user on 29.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMDreamerMapper.h"

@protocol PMFriendsApiClient;
@protocol PMImageDownloader;

@interface PMDreamerMapperImpl : NSObject <PMDreamerMapper>
@property (strong, nonatomic) id<PMFriendsApiClient> friendsApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@end
