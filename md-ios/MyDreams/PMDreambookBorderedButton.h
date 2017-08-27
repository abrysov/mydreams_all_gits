//
//  PMBorderedForDreambookButton.h
//  MyDreams
//
//  Created by user on 21.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBorderedButton.h"
#import "PMDreamerStatus.h"

typedef NS_ENUM(NSUInteger, PMDreambookBorderedButtonState) {
    PMDreambookBorderedButtonStateDefault = 0,
    PMDreambookBorderedButtonStateBordered,
    PMDreambookBorderedButtonStateBorderedWithIcon,
    PMDreambookBorderedButtonStateFilled,
};

@interface PMDreambookBorderedButton : PMBorderedButton
@property (nonatomic, assign) PMDreambookBorderedButtonState inputState;
@property (nonatomic, assign) PMDreamerStatus dreamerStatus;
@end
