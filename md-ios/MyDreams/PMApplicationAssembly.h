//
//  NNApplicationAssembly.h
//  MyDreams
//
//  Created by Иван Ушаков on 26.10.15.
//  Copyright © 2015 Perpetuum Mobile lab. All rights reserved.
//

#import <Typhoon/Typhoon.h>

@interface PMApplicationAssembly : TyphoonAssembly
- (id)applicationRouter;
- (id)baseVC;
- (id)baseLogic;
- (id)overlayWindow;
@end
