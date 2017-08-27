//
//  PMPhotoResponse.h
//  MyDreams
//
//  Created by user on 25.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationResponse.h"

@class PMPhoto;

@interface PMPhotosResponse : PMPaginationResponse
@property (strong, nonatomic, readonly) NSArray<PMPhoto*> *photos;
@end
