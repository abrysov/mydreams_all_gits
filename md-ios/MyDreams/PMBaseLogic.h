//
//  PMBaseLogic.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PMContext.h"

@interface PMBaseLogic : NSObject

#pragma mark - Properties

/** Abstract context to provide input data. */
@property (strong, nonatomic) id<PMContext> context;

/**
 Data request command. Base controller shows throbber
 during request and shows empty content view on error.
 @return Returns command using loadData method by default.
 */
@property (readonly, nonatomic) RACCommand *loadDataCommand;

/**
 Data request command. Connected to refresh control of base controller.
 @return Returns command using loadData method by default.
 */
@property (readonly, nonatomic) RACCommand *refreshDataCommand;

/**
 It indicates state of loadDataCommand progress
 It's YES only if execution of loadDataCommand is OK
 Default NO
 */
@property (nonatomic, assign, readonly) BOOL isDataLoaded;

/**
 Segues to be performed
 */
@property (readonly, nonatomic) RACSubject *performedSegues;

#pragma mark - Life Cycle

- (void)startLogic NS_REQUIRES_SUPER;

/**
 @return Should return data request signal.
 */
- (RACSignal *)loadData;

@end
