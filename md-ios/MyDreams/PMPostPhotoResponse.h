//
//  PMPostPhotoResponse.h
//  MyDreams
//
//  Created by user on 06.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"
#import "PMPostPhoto.h"

@interface PMPostPhotoResponse : PMBaseResponse
@property (strong, nonatomic, readonly) PMPostPhoto *postPhoto;
@end
