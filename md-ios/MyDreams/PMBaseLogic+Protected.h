//
//  PMBaseLogic+Protected.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"

extern NSString * const PMBaseLogicErrorDomain;

typedef NS_ENUM(NSUInteger, PMBaseLogicError) {
    PMBaseLogicErrorCannotOpenUrl = 3,
};

@interface PMBaseLogic (Protected)
@property (nonatomic, assign) BOOL isDataLoaded;

- (void)performSegueWithIdentifier:(NSString *)segue context:(id)context;
- (void)performSegueWithIdentifier:(NSString *)segue;
- (RACSignal *)openURL:(NSURL *)url;
- (RACCommand *)createRouteCommandWithSegueIdentifier:(NSString *)segueIdentifier;
@end
