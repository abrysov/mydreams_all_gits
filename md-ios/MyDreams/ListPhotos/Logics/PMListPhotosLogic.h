//
//  PMListPhotosLogic.h
//  myDreams
//
//  Created by Ivan Ushakov on 12/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"

@protocol PMListPhotosViewModel;
@protocol PMDreamerApiClient;
@protocol PMPhotoMapper;
@protocol PMProfileApiClient;

extern NSString * const PMListPhotosLogicErrorDomain;

@interface PMListPhotosLogic : PMPaginationBaseLogic
@property (strong, nonatomic) id<PMDreamerApiClient> dreamerApiClient;
@property (strong, nonatomic) id<PMProfileApiClient> profileApiClient;
@property (strong, nonatomic) id<PMPhotoMapper> photoMapper;
@property (strong, nonatomic, readonly) id<PMListPhotosViewModel> viewModel;

@property (strong, nonatomic, readonly) RACCommand *uploadPhotoCommand;
@property (strong, nonatomic, readonly) RACCommand *deletePhotoAtIndexCommand;
@end
