//
//  PMPhotoMapper.h
//  MyDreams
//
//  Created by user on 29.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//


@protocol PMPhotoMapper <NSObject>
- (NSArray *)photosToViewModels:(NSArray *)photos;
@end