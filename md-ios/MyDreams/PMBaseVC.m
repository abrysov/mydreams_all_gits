//
//  PMBaseVC.m
//  MyDreams
//
//  Created by Иван Ушаков on 16.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseVC.h"
#import "PMNibManagement.h"
#import "PMBaseLogic.h"
#import "PMLoadDataThrobberView.h"
#import "PMBlankStateView.h"
#import "PMLoadDataErrorView.h"
#import "PMToastView.h"
#import <INSPullToRefresh/UIScrollView+INSPullToRefresh.h>
#import <INSPullToRefresh/INSDefaultPullToRefresh.h>
#import <TBStateMachine/TBSMStateMachine.h>

NSString * const PMBaseVCLoadEvent = @"load";
NSString * const PMBaseVCErrorEvent = @"error";
NSString * const PMBaseVCEmptyDataEvent = @"empty data";
NSString * const PMBaseVCDataEvent = @"data";

@interface PMBaseVC ()
@property (strong, nonatomic) TBSMStateMachine *stateMachine;
@end

@implementation PMBaseVC

#pragma mark - Life Cycle

- (void)loadView
{
    [self.logic startLogic];
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupUI];
    [self setupLocalization];
    [self initStateMachine];
    [self bindUIWithLogics];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.view endEditing:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.destinationViewController isKindOfClass:[PMBaseVC class]]) {
        PMBaseVC *destinationViewController = segue.destinationViewController;
        if (sender) {
            destinationViewController.logic.context = sender;
        }
    }
}

- (void)setupUI
{
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backButton;
    
    if (self.refreshableScrollView && self.logic.refreshDataCommand) {
        @weakify(self);
        [self.refreshableScrollView ins_addPullToRefreshWithHeight:50.f handler:^(UIScrollView *scrollView) {
            @strongify(self);
            [[[self.logic.refreshDataCommand
                execute:scrollView]
                catchTo:[RACSignal empty]]
                subscribeCompleted:^{
                    [scrollView ins_endPullToRefresh];
                }];
        }];
        
        INSDefaultPullToRefresh *pullToRefresh = [[INSDefaultPullToRefresh alloc] initWithFrame:CGRectMake(0, 0, 24, 24)
                                                                                      backImage:[UIImage imageNamed:@"PullToRefreshCircleLight"]
                                                                                     frontImage:[UIImage imageNamed:@"PullToRefreshCircleDark"]];
        self.refreshableScrollView.ins_pullToRefreshBackgroundView.delegate = pullToRefresh;
        [self.refreshableScrollView.ins_pullToRefreshBackgroundView addSubview:pullToRefresh];
    }
    
    self.loadDataThrobberView = [PMLoadDataThrobberView viewFromNib];
    self.loadDataErrorView = [PMLoadDataErrorView viewFromNib];
    self.blankStateView = [PMBlankStateView viewFromNib];
}

- (void)bindUIWithLogics
{
    self.loadDataErrorView.rac_command = self.logic.loadDataCommand;
    
    @weakify(self);
    [self.logic.loadDataCommand.executing subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.stateMachine scheduleEventNamed:PMBaseVCLoadEvent data:nil];
        }
    }];
    
    [RACObserve(self.logic, isDataLoaded) subscribeNext:^(NSNumber *isDataAvailable) {
        @strongify(self);
        if ([isDataAvailable boolValue]) {
            [self.stateMachine scheduleEventNamed:PMBaseVCDataEvent data:nil];
        }
        else {
            [self.stateMachine scheduleEventNamed:PMBaseVCEmptyDataEvent data:nil];
        }
    }];
    
    [self.logic.loadDataCommand.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self.stateMachine scheduleEventNamed:PMBaseVCErrorEvent data:error.localizedDescription];
    }];
    
    [self.logic.refreshDataCommand.errors subscribeNext:^(NSError *error) {
        @strongify(self);
        [self processReloadDataError:error];
    }];
    
    [self.logic.performedSegues subscribeNext:^(RACTuple *x) {
        @strongify(self);
        [self performSegueWithIdentifier:x.first sender:x.second];
    }];
}

- (void)setupLocalization{}

#pragma mark - Exeptional states

- (UIView *)viewForStatesViewsConstraints
{
    return self.view;
}

- (void)setIsThrobberVisible:(BOOL)isThrobberVisible
{
    if (_isThrobberVisible != isThrobberVisible) {
        if (isThrobberVisible) {
            [self showLoadDataThrobberView];
        } else {
            [self hideLoadDataThrobberView];
        }
        _isThrobberVisible = isThrobberVisible;
    }
}

- (void)setIsBlankStateVisible:(BOOL)isBlankStateVisible
{
    if (_isBlankStateVisible != isBlankStateVisible) {
        _isBlankStateVisible = isBlankStateVisible;
        if (_isBlankStateVisible) {
            [self showBlankStateView];
        }
        else {
            [self hideBlankStateView];
        }
    }
}

- (void)showLoadDataThrobberView
{
    [self hideLoadDataErrorView];
    [self.view addSubview:self.loadDataThrobberView];
    @weakify(self);
    [self.loadDataThrobberView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.viewForStatesViewsConstraints);
    }];
    
    [self.loadDataThrobberView startAnimation];
}

- (void)hideLoadDataThrobberView
{
    [self.loadDataThrobberView stopAnimation];
    [self.loadDataThrobberView removeFromSuperview];
}

- (void)showLoadDataErrorView:(NSString *)errorString
{
    [self hideLoadDataThrobberView];
    [self.view addSubview:self.loadDataErrorView];
    self.loadDataErrorView.errorString = errorString;
    @weakify(self);
    [self.loadDataErrorView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.viewForStatesViewsConstraints);
    }];
}

- (void)hideLoadDataErrorView
{
    [self.loadDataErrorView removeFromSuperview];
}

- (void)showBlankStateView
{
    [self.view addSubview:self.blankStateView];
    @weakify(self);
    [self.blankStateView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.viewForStatesViewsConstraints);
    }];
}

- (void)hideBlankStateView
{
    [self.blankStateView removeFromSuperview];
}

- (void)showToastViewWithTitle:(NSString *)title buttonCommand:(RACCommand *)command topMargin:(NSInteger)margin
{
    PMToastView *toastView = [[PMToastView alloc] initWithTitle:title buttonCommand:command];
    [self.view addSubview:toastView];
    NSLayoutConstraint *toastTopConstraint = [NSLayoutConstraint constraintWithItem:toastView
                                                                          attribute:NSLayoutAttributeTop
                                                                          relatedBy:NSLayoutRelationEqual
                                                                             toItem:self.topLayoutGuide
                                                                          attribute:NSLayoutAttributeBottom
                                                                         multiplier:1.0
                                                                           constant:margin];
    [self.view addConstraint:toastTopConstraint];
}

- (void)showToastViewWithTitle:(NSString *)title buttonCommand:(RACCommand *)command
{
    [self showToastViewWithTitle:title buttonCommand:command topMargin:self.toastTopMargin];
}

- (void)processReloadDataError:(NSError *)error
{
    [self showToastViewWithTitle:error.localizedDescription buttonCommand:nil];
}

#pragma mark - PMRefreshableController

- (UIScrollView *)refreshableScrollView
{
    return nil;
}

#pragma mark - Status bar

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - state machine

- (void)initStateMachine
{
    @weakify(self);
    
    TBSMState *loadingState = [TBSMState stateWithName:@"loading"];
    loadingState.enterBlock = ^(TBSMState *source, TBSMState *target, id data){
        @strongify(self);
        [self showLoadDataThrobberView];
    };
    
    loadingState.exitBlock = ^(TBSMState *source, TBSMState *target, id data) {
        @strongify(self);
        [self hideLoadDataThrobberView];
    };
    
    TBSMState *dataState = [TBSMState stateWithName:@"data"];
    
    TBSMState *blankState = [TBSMState stateWithName:@"blank"];
    blankState.enterBlock = ^(TBSMState *source, TBSMState *target, id data){
        @strongify(self);
        [self showBlankStateView];
    };
    
    blankState.exitBlock = ^(TBSMState *source, TBSMState *target, id data) {
        @strongify(self);
        [self hideBlankStateView];
    };
    
    TBSMState *loadDataErrorState = [TBSMState stateWithName:@"load data error"];
    loadDataErrorState.enterBlock = ^(TBSMState *source, TBSMState *target, id data){
        @strongify(self);
        [self showLoadDataErrorView:data];
    };
    
    loadDataErrorState.exitBlock = ^(TBSMState *source, TBSMState *target, id data) {
        @strongify(self);
        [self hideLoadDataErrorView];
    };

    [loadingState addHandlerForEvent:PMBaseVCEmptyDataEvent target:blankState];
    [loadingState addHandlerForEvent:PMBaseVCErrorEvent target:loadDataErrorState];
    [loadingState addHandlerForEvent:PMBaseVCDataEvent target:dataState];
    
    [blankState addHandlerForEvent:PMBaseVCLoadEvent target:loadingState];
    [loadDataErrorState addHandlerForEvent:PMBaseVCLoadEvent target:loadingState];
    [dataState addHandlerForEvent:PMBaseVCLoadEvent target:loadingState];
    
    self.stateMachine = [TBSMStateMachine stateMachineWithName:@"Main"];
    self.stateMachine.states = @[loadingState, blankState, loadDataErrorState, dataState];
    self.stateMachine.initialState = blankState;
    [self.stateMachine setUp:nil];
}

#pragma mark - actions

-(IBAction)prepareForUnwind:(UIStoryboardSegue *)segue {}

@end
