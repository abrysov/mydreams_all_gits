//
//  PMCertificateDetailViewModel.h
//  MyDreams
//
//  Created by Alexey Yakunin on 20/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PMCertificateDetailViewModel <NSObject>
@property (assign, nonatomic, readonly) BOOL isNeedToShowGiftBy;
#pragma mark - dream header

@property (strong, nonatomic, readonly) UIImage* headerImage;
@property (strong, nonatomic, readonly) NSString* title;
@property (assign, nonatomic, readonly) NSUInteger likesCount;
@property (assign, nonatomic, readonly) NSUInteger commentsCount;
@property (assign, nonatomic, readonly) NSUInteger launchesCount;

#pragma mark - gift by
@property (strong, nonatomic, readonly) NSString* wish;
@property (strong, nonatomic, readonly) NSString* dreamerTopInfo;
@property (strong, nonatomic, readonly) NSString* dreamerBottomInfo;
@property (strong, nonatomic, readonly) UIImage* avatarImage;

#pragma mark - certificate
@property (strong, nonatomic, readonly) UIImage* certificateImage;
@property (strong, nonatomic, readonly) NSString* numberOfLaunches;//price
@property (strong, nonatomic, readonly) NSString* date;
@end
