//
//  PMAuthorizationVC.h
//  MyDreams
//
//  Created by Иван Ушаков on 18.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseVC.h"

@class PMSocialAuthFactory;
@class PMAlertManager;

@interface PMAuthorizationVC : PMBaseVC
@property (strong, nonatomic) PMSocialAuthFactory *socialAuthFactory;
@end
