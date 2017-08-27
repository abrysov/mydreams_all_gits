//
//  PostCommentsViewController.m
//  MyDreams
//
//  Created by Игорь on 08.11.15.
//  Copyright © 2015 Unicom. All rights reserved.
//

#import "PostCommentsViewController.h"
#import "CommonListViewController.h"
#import "ApiDataManager.h"
#import "Helper.h"
#import "CommonListViewController.h"
#import "DreamComment.h"
#import "CommentUserCell.h"
#import "DreambookRootViewController.h"

/* PostCommentsViewController copypaste */

@interface PostCommentsViewController ()
@end


@implementation PostCommentsViewController {
    CommonListViewController *listViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // скролится таблица комментов
    [self.scrollView setScrollEnabled:NO];
    
    [self.commentTextView setPlaceholder:self.commentTextViewLabel];
    self.commentTextView.bottomBorder = self.commentTextViewBorder;
    
    self.commentTextView.minimum = 3;
    self.commentTextView.maximum = 500;
    
    [self setupCommentsContent];
    
    [self.commentFormContainer.layer setShadowOffset:CGSizeMake(0, -2)];
    [self.commentFormContainer.layer setShadowColor:[[UIColor blackColor] CGColor]];
    [self.commentFormContainer.layer setShadowOpacity:0.2];
    [self.commentFormContainer.layer setShadowRadius:0.5];
    self.commentFormContainer.layer.shouldRasterize = YES;
    self.commentFormContainer.layer.rasterizationScale = UIScreen.mainScreen.scale;
    
    self.commentFormBlockHeight.constant = 60;
    
    [self fitContentViewToScreen];
    self.contentViewHeight.constant -= 50; // высота табов
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.commentTextView resignFirstResponder];
}

- (void)setupCommentsContent {
    [self setupListViewController];
    
    [self addChildViewController:listViewController];
    listViewController.view.frame = CGRectMake(0, 0, self.commentsContainer.frame.size.width, self.commentsContainer.frame.size.height);
    [self.commentsContainer addSubview:listViewController.view];
    [listViewController didMoveToParentViewController:self];
}

- (void)setupListViewController {
    listViewController = [[CommonListViewController alloc] initWithNibName:@"CommonListViewController" bundle:nil];
    
    [listViewController initWithRetreiver:^(Pager *pager, CommonListRetreiveCallbackBlock callback) {
        [ApiDataManager postcomments:self.postId pager:pager success:^(NSInteger total, NSArray<DreamComment> *items) {
            callback(total, items);
        } error:^(NSString *error) {
            [self showAlert:error];
        }];
    } andCellType:[CommentUserCell class] andCellInitializer:^(UITableViewCell *cell, id listItem) {
        CommentUserCell *itemCell = (CommentUserCell *)cell;
        DreamComment *item = (DreamComment *)listItem;
        [itemCell initWithComment:item];
    } andSectionNameDelegate:nil andSelectItem:^(id listItem) {
        DreamComment *item = (DreamComment *)listItem;
        [self navigateFlybook:item.user.id];
    }];
}

- (void)navigateFlybook:(NSInteger)userId {
    DreambookRootViewController *dreambookViewController = [[DreambookRootViewController alloc] initWithNibName:@"DreambookRootViewController" bundle:nil];
    dreambookViewController.userId = userId;
    [self.navigationController pushViewController:dreambookViewController animated:YES];
}

- (BOOL)validateComment {
    if (![self.commentTextView checkConstraints]) {
        [self showNotification:@"_DREAM_COMMENT_NO"];
        return NO;
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if (textView == self.commentTextView) {
        [self.view setNeedsLayout];
        self.commentFormBlockHeight.constant = 120;
        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            //self.commentsContainerHeight.constant += 280;
            [self.view layoutIfNeeded];
        }];
    }
    [super textViewDidBeginEditing:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if (textView == self.commentTextView) {
        [self.contentView setNeedsLayout];
        self.commentFormBlockHeight.constant = 60;
        // ! нужно чтобы схлопывалось вью после ухода клавы
        [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
            //self.commentsContainerHeight.constant -= 280;
            [self.view layoutIfNeeded];
        }];
    }
    [super textViewDidEndEditing:textView];
}

- (IBAction)commentSubmitTouch:(id)sender {
    if (![self validateComment]) {
        return;
    }
    
    UIAlertView *alert = [self showConfirmationDialog:@"_DREAM_COMMENT_CONFIRM" delegate:self];
    alert.tag = 44444;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 44444) {
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
        return;
    }
    
    switch (buttonIndex) {
        case 1:
        {
            self.commentSubmitButton.enabled = NO;
            [ApiDataManager postpostcomment:self.postId text:self.commentTextView.text success:^{
                self.commentSubmitButton.enabled = YES;
                [listViewController reload];
                [self.delegate needUpdateTabs:self];
            } error:^(NSString *error) {
                [self showAlert:error];
                self.commentSubmitButton.enabled = YES;
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
    if (alertView.tag != 44444) {
        [super alertView:alertView clickedButtonAtIndex:buttonIndex];
        return;
    }
    
    switch (buttonIndex) {
        case 1:
        {
            self.commentTextView.text = nil;
            [self.view endEditing:YES];
        }
            break;
            
        default:
            break;
    }
}

@end
