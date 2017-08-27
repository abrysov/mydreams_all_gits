//
//  PMRegistrationVC.h
//  MyDreams
//
//  Created by Иван Ушаков on 01.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseAuthentificationVC.h"
#import "PMSocialAuthFactory.h"

@interface PMRegistrationVC : PMBaseAuthentificationVC
@property (strong, nonatomic) PMSocialAuthFactory *socialAuthFactory;
@end
