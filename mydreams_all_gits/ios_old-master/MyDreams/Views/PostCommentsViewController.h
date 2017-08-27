//
//  PostCommentsViewController.h
//  MyDreams
//
//  Created by Игорь on 08.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonLabel.h"
#import "CommonTextView.h"

@interface PostCommentsViewController : BaseViewController

@property (assign, nonatomic) NSInteger postId;

@property (weak, nonatomic) id<TabsRootViewControllerDelegate> delegate;

@property (weak, nonatomic) IBOutlet CommonLabel *commentTextViewLabel;
@property (weak, nonatomic) IBOutlet CommonTextView *commentTextView;
@property (weak, nonatomic) IBOutlet UIView *commentTextViewBorder;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentFormBlockHeight;
@property (weak, nonatomic) IBOutlet UIView *commentsContainer;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *commentsContainerHeight;
@property (weak, nonatomic) IBOutlet UIButton *commentSubmitButton;
@property (weak, nonatomic) IBOutlet UIView *commentFormContainer;

- (IBAction)commentSubmitTouch:(id)sender;

@end
