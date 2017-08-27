//
//  PostMainViewController.h
//  MyDreams
//
//  Created by Игорь on 08.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "BaseViewController.h"
#import "Post.h"

@interface PostMainViewController : BaseViewController

@property (retain, nonatomic) Post *post;

@property (weak, nonatomic) id<TabsRootViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *dreamContainer;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
@property (weak, nonatomic) IBOutlet UILabel *textLabel;

- (IBAction)likeButtonTouch:(id)sender;

@end
