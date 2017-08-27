//
//  PMAlertManager.h
//  MyDreams
//
//  Created by user on 29.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface PMAlertManager : NSObject
- (void)showAlertWithError:(NSError *)error in:(UIViewController *)controller;
- (void)processErrorsOfCommand:(RACCommand *)command in:(UIViewController *)controller;
@end
