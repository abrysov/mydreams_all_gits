//
//  PMBaseVC.h
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PMBaseLogic;
@class PMAlertManager;
@class PMLoadDataThrobberView;
@class PMBlankStateView;
@class PMLoadDataErrorView;

@protocol PMRefreshableVC <NSObject>
@property (readonly, nonatomic) UIScrollView *refreshableScrollView;
@end

@interface PMBaseVC : UIViewController <PMRefreshableVC>
@property (strong, nonatomic) PMBaseLogic *logic;
@property (strong, nonatomic) PMAlertManager *alertManager;

@property (assign, nonatomic, readonly) NSInteger toastTopMargin;

#pragma mark - Exeptional states

/**
 Throbber view covering the whole controller's view.
 Automatically shown on data loading via loadDataCommand of logics.
 */
@property (nonatomic, strong) PMLoadDataThrobberView *loadDataThrobberView;
/**
 State of throbber view. It can be changed manualy
 */
@property (nonatomic, assign) BOOL isThrobberVisible;
/**
 Error view covering the whole controller's view.
 Automatically shown on error of data loading via loadDataCommand of logics.
 */
@property (nonatomic, strong) PMLoadDataErrorView *loadDataErrorView;
/**
 Blank state view covering the whole controller's view. For manual use.
 */
@property (nonatomic, strong) PMBlankStateView *blankStateView;
/**
 State of blank state view. It can be changed manualy
 */
@property (nonatomic, assign) BOOL isBlankStateVisible;

#pragma mark - Life Cycle

- (void)viewDidLoad NS_REQUIRES_SUPER;

/**
 Method for initial setup without using logics.
 */
- (void)setupUI NS_REQUIRES_SUPER;

/**
 Method for setting up localizations
 */
- (void)setupLocalization NS_REQUIRES_SUPER;

/**
 Method for setting up bindings and reading constant data from logics.
 The logics are fully initialized at this moment.
 */
- (void)bindUIWithLogics NS_REQUIRES_SUPER;


- (void)showToastViewWithTitle:(NSString *)title buttonCommand:(RACCommand *)command topMargin:(NSInteger)margin;
- (void)showToastViewWithTitle:(NSString *)title buttonCommand:(RACCommand *)command;

@end
