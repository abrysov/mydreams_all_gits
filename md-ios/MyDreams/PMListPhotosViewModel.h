//
//  PMListPhotosViewModel.h
//  MyDreams
//
//  Created by Иван Ушаков on 18.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMPhotoViewModel;

@protocol PMListPhotosViewModel <NSObject>
@property (strong, nonatomic, readonly) NSArray<PMPhotoViewModel> *photos;
@property (assign, nonatomic, readonly) BOOL isMe;
@property (assign, nonatomic) float progress;
@end
