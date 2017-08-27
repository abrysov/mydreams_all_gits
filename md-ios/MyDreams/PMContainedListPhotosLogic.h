//
//  PMListPhotosLogic.h
//  MyDreams
//
//  Created by user on 06.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMContainedListPhotosViewModel.h"
#import "PMContainedListPhotosLogicDelegate.h"

@protocol PMDreamerApiClient;
@protocol PMPhotoMapper;
@protocol PMProfileApiClient;

extern NSString * const PMContainedListPhotosLogicErrorDomain;

@interface PMContainedListPhotosLogic : PMPaginationBaseLogic <PMContainedListPhotosLogicDelegate>
@property (strong, nonatomic) id<PMDreamerApiClient> dreamerApiClient;
@property (strong, nonatomic) id<PMPhotoMapper> photoMapper;
@property (strong, nonatomic) id<PMProfileApiClient> profileApiClient;
@property (strong, nonatomic, readonly) id<PMContainedListPhotosViewModel> viewModel;
@property (strong, nonatomic, readonly) RACCommand *deletePhotoAtIndexCommand;
@end
