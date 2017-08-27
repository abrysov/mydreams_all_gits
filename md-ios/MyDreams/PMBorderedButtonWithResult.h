
//
//  PMBorderedButtonWithFallOfAlpha.h
//  MyDreams
//
//  Created by user on 04.05.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBorderedButton.h"
typedef NS_ENUM(NSUInteger, PMBorderedButtonWithResultState) {

    PMBorderedButtonWithResultStateInactive,
        PMBorderedButtonWithResultStateActive,
};

@interface PMBorderedButtonWithResult : PMBorderedButton
@property (nonatomic, assign) PMBorderedButtonWithResultState inputState;

@end
