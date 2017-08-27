//
//  PMListPhotosVC.h
//  MyDreams
//
//  Created by user on 06.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseVC.h"
#import "PMContainedListPhotosLogic.h"

@class PMContainedListPhotosVC;

@protocol PMContainedListPhotosVCDelegate <NSObject>
- (void)containedListPhotoVC:(PMContainedListPhotosVC *)listPhotoVC photosLoaded:(BOOL)photosLoaded;
@end

@interface PMContainedListPhotosVC : PMBaseVC
@property (strong, nonatomic) PMContainedListPhotosLogic *logic;
@property (weak, nonatomic) id <PMContainedListPhotosVCDelegate> delegate;
@end
