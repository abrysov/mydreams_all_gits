//
//  PMPhotoResponse.h
//  MyDreams
//
//  Created by Иван Ушаков on 19.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseModel.h"

@class PMPhoto;

@interface PMPhotoResponse : PMBaseModel
@property (strong, nonatomic, readonly) PMPhoto *photo;
@end
