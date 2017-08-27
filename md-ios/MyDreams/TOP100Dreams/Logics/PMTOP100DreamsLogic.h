//
//  PMTOP100DreamsLogic.h
//  myDreams
//
//  Created by AlbertA on 22/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"

@protocol PMDreamApiClient;
@protocol PMImageDownloader;
@protocol PMDreamsViewModel;
@protocol PMLikeApiClient;

extern NSString * const PMTOP100DreamsLogicErrorDomain;

@interface PMTOP100DreamsLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMDreamApiClient> dreamApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@property (strong, nonatomic) id<PMLikeApiClient> likeApiClient;
@property (strong, nonatomic, readonly) id<PMDreamsViewModel> dreamsViewModel;
@end
