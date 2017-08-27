//
//  PMMenuItemView.h
//  MyDreams
//
//  Created by Иван Ушаков on 18.03.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PMMenuItem.h"

@class PMMenuItemView;

@protocol PMMenuItemViewDelegate <NSObject>
@optional
- (void)didSelectItem:(PMMenuItemView *)item;
@end

@interface PMMenuItemView : UIView
@property (nonatomic, strong) IBInspectable UIImage *icon;
@property (nonatomic, strong) IBInspectable NSString *title;
@property (nonatomic, strong) NSString *bage;
@property (nonatomic, assign) PMMenuItem menuItem;
@property (nonatomic, weak) id<PMMenuItemViewDelegate> delegate;

- (void)deselect;
- (void)select;

@end
