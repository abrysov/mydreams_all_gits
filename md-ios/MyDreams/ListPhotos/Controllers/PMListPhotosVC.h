//
//  PMListPhotosVC.h
//  myDreams
//
//  Created by Ivan Ushakov on 12/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseVC.h"

@class PMListPhotosLogic;
@class PMFullscreenLoadingView;

@interface PMListPhotosVC : PMBaseVC
@property (strong, nonatomic) PMFullscreenLoadingView* loadingView;
@end
