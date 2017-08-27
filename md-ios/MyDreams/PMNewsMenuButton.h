//
//  PMNewsMenuButton.h
//  MyDreams
//
//  Created by user on 01.08.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PMNewsMenuType) {
    PMNewsMenuTypeNewsFeed,
    PMNewsMenuTypeUpdating,
    PMNewsMenuTypeRecommendations,
    PMNewsMenuTypeComments
};

@interface PMNewsMenuButton : UIButton
@property (nonatomic, assign) PMNewsMenuType type;
@end
