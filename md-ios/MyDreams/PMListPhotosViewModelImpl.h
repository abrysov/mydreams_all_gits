//
//  PMListPhotosViewModelImpl.h
//  MyDreams
//
//  Created by Иван Ушаков on 18.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMListPhotosViewModel.h"

@protocol PMPhotoViewModel;

@interface PMListPhotosViewModelImpl : NSObject <PMListPhotosViewModel>
@property (strong, nonatomic) NSArray<PMPhotoViewModel> *photos;
@property (assign, nonatomic) BOOL isMe;
@property (assign, nonatomic) float progress;
@end
