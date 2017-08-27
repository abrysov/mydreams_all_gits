//
//  PMFulfillDreamViewModel.h
//  MyDreams
//
//  Created by user on 19.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//


#import <Foundation/Foundation.h>


@protocol PMFulfillDreamViewModel <NSObject>
@property (nonatomic, strong, readonly) UIImage *photo;
@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, strong, readonly) NSString *dreamDescription;
@property (nonatomic, assign, readonly) BOOL restrictionLevelPrivate;
@property (nonatomic, assign, readonly) BOOL restrictionLevelFriends;
@property (nonatomic, assign, readonly) BOOL restrictionLevelPublic;
@end
