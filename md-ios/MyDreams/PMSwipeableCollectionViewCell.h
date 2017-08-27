//
//  PMSwipeableCollectionViewCell.h
//  MyDreams
//
//  Created by Alexey Yakunin on 02/08/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMSwipeButton.h"

@interface PMSwipeableCollectionViewCell : UICollectionViewCell
@property (strong, nonatomic) NSArray <PMSwipeButton *> *buttons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint* rightConstraint;
@property (weak, nonatomic) IBOutlet UIView* scrollableContentView;
@end
