//
//  PMDreamClubHeaderPMDreamClubHeaderVC.h
//  myDreams
//
//  Created by AlbertA on 08/08/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseVC.h"

@class PMDreamClubHeaderVC;

@protocol PMDreamClubHeaderDelegate <NSObject>
-(void)dreamclubHeaderVC:(PMDreamClubHeaderVC *)dreamclubHeaderVC photosLoaded:(BOOL)photosLoaded;
@end

@interface PMDreamClubHeaderVC : PMBaseVC
@property (weak, nonatomic) id <PMDreamClubHeaderDelegate> delegate;
@end
