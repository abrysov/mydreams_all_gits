//
//  ProposedCell.h
//  MyDreams
//
//  Created by Игорь on 17.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

@interface ProposedCell : UITableViewCell

- (void)initUIWith:(NSInteger)proposed appearence:(AppearenceStyle)appearence;

@property (weak, nonatomic) IBOutlet UIView *proposedContainer;

@property (weak, nonatomic) IBOutlet UILabel *proposedFormatLabel;
@property (weak, nonatomic) IBOutlet UIImageView *proposedCloseView;
@property (weak, nonatomic) IBOutlet UIImageView *diamondIconImage;

- (void)initHiding:(id)target action:(SEL)action;
- (void)initGoProposed:(id)target action:(SEL)action;

@end
