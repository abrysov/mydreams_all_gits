//
//  DreamCommentsViewController.h
//  MyDreams
//
//  Created by Игорь on 26.09.15.
//  Copyright (c) 2015 Unicom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CommonTextView.h"
#import "CommonLabel.h"

@interface DreamCommentsViewController : BaseViewController

@property (assign, nonatomic) NSInteger dreamId;

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
