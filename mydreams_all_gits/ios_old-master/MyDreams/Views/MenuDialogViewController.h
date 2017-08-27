//
//  MenuDialogViewController.h
//  Unicom
//
//  Created by Игорь on 28.06.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWRevealViewController.h"

@interface MenuDialogViewController : UIViewController <UIViewControllerAnimatedTransitioning, SWRevealViewControllerDelegate>

@property bool presenting;

@property (strong, nonatomic) IBOutlet UIView *rootView;
@property (weak, nonatomic) IBOutlet UIView *menuPanel;
@property (weak, nonatomic) IBOutlet UIImageView *headerBackgroundImageView;
@property (weak, nonatomic) IBOutlet UIView *headerBackgroundView;

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *fullnameLabel;
@property (weak, nonatomic) IBOutlet UILabel *emailLabel;

@property (weak, nonatomic) IBOutlet UILabel *addDreamItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *flybookItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *newsItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *topItemLabel;
@property (weak, nonatomic) IBOutlet UILabel *dreamersItemLabel;

@property (weak, nonatomic) IBOutlet UIView *addDreamItemView;
@property (weak, nonatomic) IBOutlet UIView *flybookItemView;
@property (weak, nonatomic) IBOutlet UIView *friendsItemView;
@property (weak, nonatomic) IBOutlet UIView *newsItemView;
@property (weak, nonatomic) IBOutlet UIView *topItemView;
@property (weak, nonatomic) IBOutlet UIView *dreamersItemView;

@property (weak, nonatomic) IBOutlet UIView *flybookItemPlankView;

- (void)setActiveMenuItem:(NSInteger)menuIndex;

@end
