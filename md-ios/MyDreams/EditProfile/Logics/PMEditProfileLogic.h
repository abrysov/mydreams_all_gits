//
//  PMEditProfileLogic.h
//  myDreams
//
//  Created by AlbertA on 26/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMImageForm.h"
#import "PMEditProfileViewModel.h"

@protocol PMProfileApiClient;
@protocol PMImageDownloader;

typedef NS_ENUM(NSUInteger, PMEditProfileLogicError) {
    PMEditProfileLogicErrorInvalidInput = 3,
};

extern NSString * const PMEditProfileLogicErrorDomain;

@interface PMEditProfileLogic : PMBaseLogic
@property (nonatomic, strong) id<PMProfileApiClient> profileApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@property (nonatomic, strong, readonly) id<PMEditProfileViewModel> viewModel;
@property (nonatomic, strong, readonly) RACCommand *backCommand;
@property (nonatomic, strong, readonly) RACCommand *setBirthdayCommand;
@property (nonatomic, strong, readonly) RACCommand *sendCommand;
@property (nonatomic, strong, readonly) RACCommand *toSelectCountryCommand;
@property (nonatomic, strong, readonly) RACCommand *toSelectLocalityCommand;
@property (nonatomic, strong, readonly) RACCommand *selectGenderCommand;
@property (nonatomic, strong, readonly) RACChannelTerminal *firstNameTerminal;
@property (nonatomic, strong, readonly) RACChannelTerminal *secondNameTerminal;
- (void)setAvatar:(UIImage *)avatar;
@end
