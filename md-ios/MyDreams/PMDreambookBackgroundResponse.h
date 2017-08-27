//
//  PMDreambookBackgroundResponse.h
//  MyDreams
//
//  Created by user on 25.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseResponse.h"
#import "PMCroppedImage.h"

@interface PMDreambookBackgroundResponse : PMBaseResponse
@property (strong, nonatomic, readonly) PMCroppedImage *image;
@end
