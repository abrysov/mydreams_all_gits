//
//  PMAddDreamLogic.m
//  myDreams
//
//  Created by AlbertA on 16/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMAddFulfilledDreamLogic.h"
#import "DreambookSegues.h"
#import "PMDreamApiClient.h"
#import "PMDreamForm.h"
#import "PMBaseLogic+Protected.h"
#import "DreambookSegues.h"
#import "PMAddSuccessfulDreamViewModelImpl.h"

NSString * const PMAddDreamLogicErrorDomain = @"com.mydreams.AddDream.logic.error";

@interface PMAddFulfilledDreamLogic ()
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *sendDreamCommand;
@property (nonatomic, strong) PMDreamForm *dreamForm;
@property (nonatomic, strong) RACChannelTerminal *titleDreamTerminal;
@property (nonatomic, strong) PMAddSuccessfulDreamViewModelImpl *viewModel;
@property (nonatomic, strong) RACSubject *progressSubject;
@end

@implementation PMAddFulfilledDreamLogic

- (void)startLogic
{
    [super startLogic];
    self.dreamForm = [[PMDreamForm alloc] init];

    RACSignal *dreamFullFormSignal =  [[RACSignal
        combineLatest:@[
            RACObserve(self.dreamForm, isValidTitle),
            RACObserve(self.dreamForm, isValidDescription),
            RACObserve(self.dreamForm, isValidPhoto)
        ]] map:^id(RACTuple *tuple) {
            NSNumber *isValidTitle = tuple.first;
            NSNumber *isValidDescription = tuple.second;
            NSNumber *isValidPhoto = tuple.third;
            return @([isValidTitle boolValue] && [isValidDescription boolValue] && [isValidPhoto boolValue]);
        }];

    self.backCommand = [self createBackCommand];
    self.sendDreamCommand = [self createSendDreamCommandWithEnabledSignal:dreamFullFormSignal];
    
    self.titleDreamTerminal = RACChannelTo(self.dreamForm, title);
    self.dreamForm.isCameTrue = @YES;
    self.viewModel = [[PMAddSuccessfulDreamViewModelImpl alloc] initWithDreamForm:self.dreamForm];
    
    self.progressSubject = [RACSubject subject];
    [self.progressSubject subscribeNext:^(NSProgress *progress) {
        self.viewModel.progress = (float)progress.completedUnitCount / progress.totalUnitCount;
    }];
}

- (void)setPhoto:(UIImage *)photo
{
    self.dreamForm.photo = photo;
}

- (void)setDescriptionDream:(NSString *)descriptionDream
{
    self.dreamForm.dreamDescription = descriptionDream;
}

#pragma mark - private

- (RACCommand *)createBackCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self performSegueWithIdentifier:kPMSegueIdentifierCloseAddFulfillDreamVC];
        return [RACSignal empty];
    }];
}

- (RACCommand *)createSendDreamCommandWithEnabledSignal:(RACSignal *)enabledSignal
{
    @weakify(self);
    return [[RACCommand alloc] initWithEnabled:enabledSignal signalBlock:^RACSignal *(id input) {
        @strongify(self);
        return [[self.dreamApiClient createDream:self.dreamForm progress:self.progressSubject]
            doNext:^(id x) {
                @strongify(self);
                [self performSegueWithIdentifier:kPMSegueIdentifierCloseAddFulfillDreamVC];
            }];
        }];
}

@end
