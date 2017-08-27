//
//  DreamViewController.h
//  MyDreams
//
//  Created by Игорь on 18.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "Dream.h"

@interface DreamMainViewController : BaseViewController<UIAlertViewDelegate>

@property (retain, nonatomic) Dream *dream;

@property (weak, nonatomic) id<TabsRootViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *dreamContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIButton *giftButton;

- (IBAction)likeButtonTouch:(id)sender;
- (IBAction)giftTouch:(id)sender;

@end
