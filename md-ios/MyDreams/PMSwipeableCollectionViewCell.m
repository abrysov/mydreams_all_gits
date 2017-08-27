//
//  PMSwipeableCollectionViewCell.m
//  MyDreams
//
//  Created by Alexey Yakunin on 02/08/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMSwipeableCollectionViewCell.h"

@interface PMSwipeableCollectionViewCell () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, assign) CGPoint panStartPoint;
@property (nonatomic, assign) CGFloat startingRightLayoutConstraintConstant;
@end

static CGFloat const kPMSwipeableCollectionViewCellBounceValue = 10.0f;

@implementation PMSwipeableCollectionViewCell

- (void)awakeFromNib
{
	self.panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panThisCell:)];
	self.panRecognizer.delegate = self;
	[self.scrollableContentView addGestureRecognizer:self.panRecognizer];
}

- (void)prepareForReuse {
	[super prepareForReuse];
	[self resetConstraintContstantsToZero:NO];
}

- (void)setButtons:(NSArray <PMSwipeButton *> *)buttons
{
	if (self->_buttons != nil)
	{
		[self->_buttons makeObjectsPerformSelector:@selector(removeFromSuperview)];
	}
	self->_buttons = buttons;
	CGFloat width = (CGRectGetWidth(self.bounds) / 2 ) / buttons.count;
	NSInteger i = 0;
	for (UIButton* button in self->_buttons)
	{
		button.frame = CGRectMake(CGRectGetWidth(self.bounds) - width * (i + 1), 0, width ,CGRectGetHeight(self.bounds));
		[self.subviews.firstObject insertSubview:button atIndex:0];
		[button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
		i++;
	}
}

- (void)buttonPressed: (PMSwipeButton *)button
{
	if (button.callback)
	{
		button.callback((UITableViewCell *)self);
	}
}
#pragma mark - private

#pragma mark - Gesture

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

#pragma mark - swipe logic
//based on https://www.raywenderlich.com/62435/make-swipeable-table-view-cell-actions-without-going-nuts-scroll-views
- (void)panThisCell:(UIPanGestureRecognizer *)recognizer {
	switch (recognizer.state) {
		case UIGestureRecognizerStateBegan:
			[self panGestureRecognizerStateBegan:recognizer];
			break;
		case UIGestureRecognizerStateChanged:
			[self panGestureRecognizerStateChanged:recognizer];
			break;
		case UIGestureRecognizerStateEnded:
			[self panGestureRecognizerStateEnded:recognizer];
			break;
		case UIGestureRecognizerStateCancelled:
			[self panGestureRecognizerStateCanceled:recognizer];
			break;
		default:
			break;
	}
}

#pragma mark - Actions for states
- (void)panGestureRecognizerStateBegan:(UIPanGestureRecognizer *)recognizer
{
	self.panStartPoint = [recognizer translationInView:self.scrollableContentView];
	self.startingRightLayoutConstraintConstant = self.rightConstraint.constant;
}

- (void)panGestureRecognizerStateChanged:(UIPanGestureRecognizer *)recognizer
{
	CGPoint currentPoint = [recognizer translationInView:self.scrollableContentView];
	CGFloat deltaX = currentPoint.x - self.panStartPoint.x;
	BOOL panningLeft = (currentPoint.x < self.panStartPoint.x);
	if (self.startingRightLayoutConstraintConstant == 0)
	{
		[self updateConstraintsForIntitalStateOfSwipeWithPanningLeft:panningLeft andDeltaX:deltaX];
	}
	else
	{
		[self updateConstraintsForNotInitialStateOfSwipeWithPanningLeft:panningLeft adnDeltaX:deltaX];
	}
	
	self.leftConstraint.constant = -self.rightConstraint.constant;
}

- (void)updateConstraintsForIntitalStateOfSwipeWithPanningLeft:(BOOL)panningLeft andDeltaX:(CGFloat)deltaX
{
	if (!panningLeft) {
		CGFloat constant = MAX(-deltaX, 0);
		if (constant == 0)
		{
			[self resetConstraintContstantsToZero:YES];
		}
		else
		{
			self.rightConstraint.constant = constant;
		}
	}
	else
	{
		CGFloat constant = MIN(-deltaX, [self buttonTotalWidth]);
		if (constant == [self buttonTotalWidth])
		{
			[self setConstraintsToShowAllButtons:YES];
		}
		else
		{
			self.rightConstraint.constant = constant;
		}
	}
}


- (void)updateConstraintsForNotInitialStateOfSwipeWithPanningLeft:(BOOL)panningLeft adnDeltaX:(CGFloat)deltaX
{
	CGFloat adjustment = self.startingRightLayoutConstraintConstant - deltaX;
	if (!panningLeft)
	{
		CGFloat constant = MAX(adjustment, 0);
		if (constant == 0)
		{
			[self resetConstraintContstantsToZero:YES];
		}
		else
		{
			self.rightConstraint.constant = constant;
		}
	} else {
		CGFloat constant = MIN(adjustment, [self buttonTotalWidth]);
		if (constant == [self buttonTotalWidth])
		{
			[self setConstraintsToShowAllButtons:YES];
		}
		else
		{
			self.rightConstraint.constant = constant;
		}
	}
}


- (void)panGestureRecognizerStateEnded:(UIPanGestureRecognizer *)recognizer
{
	if (self.startingRightLayoutConstraintConstant == 0)
	{
		CGFloat halfOfButtonOne = CGRectGetWidth(self.buttons.firstObject.frame) / 2;
		if (self.rightConstraint.constant >= halfOfButtonOne)
		{
			[self setConstraintsToShowAllButtons:YES];
		}
		else
		{
			[self resetConstraintContstantsToZero:YES];
		}
	}
	else
	{
		CGFloat halfWidthOfButtons = (CGRectGetWidth(self.buttons.firstObject.frame) * self.buttons.count / 2);
		if (self.rightConstraint.constant >= halfWidthOfButtons)
		{
			[self setConstraintsToShowAllButtons:YES];
		}
		else
		{
			[self resetConstraintContstantsToZero:YES];
		}
	}
}

- (void)panGestureRecognizerStateCanceled:(UIPanGestureRecognizer *)recognizer
{
	if (self.startingRightLayoutConstraintConstant == 0)
	{
		[self resetConstraintContstantsToZero:YES];
	}
	else
	{
		[self setConstraintsToShowAllButtons:YES];
	}
}

- (CGFloat)buttonTotalWidth {
	return CGRectGetWidth(self.bounds) / 2;
}

- (void)resetConstraintContstantsToZero:(BOOL)animated
{
	if (self.startingRightLayoutConstraintConstant == 0 &&
		self.rightConstraint.constant == 0) {
		return;
	}

	self.rightConstraint.constant = -kPMSwipeableCollectionViewCellBounceValue;
	self.leftConstraint.constant = kPMSwipeableCollectionViewCellBounceValue;

	[self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
		self.rightConstraint.constant = 0;
		self.leftConstraint.constant = 0;
		
		[self updateConstraintsIfNeeded:animated completion:^(BOOL finished) {
			self.startingRightLayoutConstraintConstant = self.rightConstraint.constant;
		}];
	}];
}

- (void)setConstraintsToShowAllButtons:(BOOL)animated
{
	if (self.startingRightLayoutConstraintConstant == [self buttonTotalWidth] &&
		self.rightConstraint.constant == [self buttonTotalWidth])
	{
		return;
	}

	self.leftConstraint.constant = -[self buttonTotalWidth] - kPMSwipeableCollectionViewCellBounceValue;
	self.rightConstraint.constant = [self buttonTotalWidth] + kPMSwipeableCollectionViewCellBounceValue;

	[self updateConstraintsIfNeeded:animated completion:^(BOOL finished)
	{
		self.leftConstraint.constant = -[self buttonTotalWidth];
		self.rightConstraint.constant = [self buttonTotalWidth];
	
		[self updateConstraintsIfNeeded:animated completion:^(BOOL finished)
		{
			self.startingRightLayoutConstraintConstant = self.rightConstraint.constant;
		}];
	}];
}

- (void)updateConstraintsIfNeeded:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
	float duration = 0;
	if (animated)
	{
		duration = 0.1;
	}

	[UIView animateWithDuration:duration delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
		[self layoutIfNeeded];
	} completion:completion];
}
@end
