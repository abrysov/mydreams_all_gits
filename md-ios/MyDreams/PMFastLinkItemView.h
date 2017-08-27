//
//  PMFastLinkItemView.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.06.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMMenuItem.h"

@class PMFastLinkItemView;

@protocol PMFastLinkItemViewDelegate <NSObject>
@optional
- (void)didSelectFastLinkItemView:(PMFastLinkItemView *)item;
@end

@interface PMFastLinkItemView : UIView
@property (strong, nonatomic) IBInspectable UIImage *icon;
@property (strong, nonatomic) IBInspectable NSString *title;
@property (assign, nonatomic) BOOL selected;
@property (nonatomic, assign) PMMenuItem menuItem;
@property (weak, nonatomic) id<PMFastLinkItemViewDelegate> delegate;

@property (strong, nonatomic) UIColor *normalTintColor;
@property (strong, nonatomic) UIColor *selectedTintColor;
@property (strong, nonatomic) UIColor *textColor;

- (void)deselect;
- (void)select;
@end
