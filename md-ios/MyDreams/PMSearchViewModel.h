//
//  PMSearchViewModel.h
//  MyDreams
//
//  Created by user on 26.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PMSearchType) {
    PMSearchTypeDream,
    PMSearchTypeDreamer,
    PMSearchTypePost
};

@protocol PMSearchViewModel
@property (strong, nonatomic, readonly) NSArray *items;
@property (assign, nonatomic, readonly) PMSearchType type;
@end
