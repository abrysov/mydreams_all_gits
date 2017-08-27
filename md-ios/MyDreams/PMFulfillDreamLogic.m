//
//  PMFulfillDreamLogic.m
//  myDreams
//
//  Created by AlbertA on 18/05/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMFulfillDreamLogic.h"
#import "PMDreamForm.h"
#import "PMFulfillDreamViewModelImpl.h"
#import "PMBaseLogic+Protected.h"
#import "DreambookSegues.h"
#import "PMDreamApiClient.h"
#import "PMApplicationRouter.h"
#import "PMMenuItem.h"

NSString * const PMFulfillDreamLogicErrorDomain = @"com.mydreams.FulfillDream.logic.error";

@interface PMFulfillDreamLogic ()
@property (nonatomic, strong) RACCommand *sendDreamCommand;
@property (nonatomic, strong) RACCommand *changeRestrictionLevelCommand;
@property (nonatomic, strong) RACCommand *toDreambookCommand;
@property (nonatomic, strong) PMDreamForm *dreamForm;
@property (nonatomic, strong) RACChannelTerminal *titleDreamTerminal;

@property (nonatomic, strong) PMFulfillDreamViewModelImpl *viewModel;
@property (nonatomic, strong) RACSubject *progressSubject;
@end

@implementation PMFulfillDreamLogic

- (void)startLogic
{
    [super startLogic];
    [self resetData];
    
    self.sendDreamCommand = [self createSendDreamCommand];
    self.changeRestrictionLevelCommand = [self createChangeRestrictionLevelCommand];
    self.toDreambookCommand = [self createToDreambookCommand];

    self.titleDreamTerminal = RACChannelTo(self, dreamForm.title);

    self.progressSubject = [RACSubject subject];
    [self.progressSubject subscribeNext:^(NSProgress *progress) {
        self.viewModel.progress = (float)progress.completedUnitCount / progress.totalUnitCount;
    }];
}

- (void)setPhoto:(UIImage *)photo
{
    self.dreamForm.photo = photo;
}

- (UIImage *)photo
{
    return self.dreamForm.photo;
}

- (void)setDescriptionDream:(NSString *)descriptionDream
{
    self.dreamForm.dreamDescription = descriptionDream;
}

- (NSString *)descriptionDream
{
    return self.dreamForm.dreamDescription;
}

#pragma mark - private
    
- (void)resetData
{
    self.dreamForm = [[PMDreamForm alloc] init];
    self.dreamForm.isCameTrue = @NO;
    self.viewModel = [[PMFulfillDreamViewModelImpl alloc] initWithDreamForm:self.dreamForm];
}

- (RACCommand *)createToDreambookCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self.router openMenuItem:PMMenuItemMyDreambook];
        return [RACSignal empty];
    }];
}
                               
- (RACCommand *)createSendDreamCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self validate];
        if ([self isValidInput]) {
            return [self.dreamApiClient createDream:self.dreamForm progress:self.progressSubject];
        }
        NSError *error = [NSError errorWithDomain:PMFulfillDreamLogicErrorDomain
                                             code:PMFulfillDreamLogicErrorInvalidInput
                                         userInfo:@{NSLocalizedDescriptionKey:[self errorMessage]}];
        return [RACSignal error:error];
    }];
}

- (RACCommand *)createChangeRestrictionLevelCommand
{
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(NSNumber *input) {
        PMDreamRestrictionLevel level = [input integerValue];
        self.dreamForm.restrictionLevel = level;
        return [RACSignal empty];
    }];
}

- (NSString *)errorMessage
{
    if (!self.dreamForm.isValidTitle)
        return NSLocalizedString(@"dreambook.fulfill_dream.invalid_title", nil);
    if (!self.dreamForm.isValidDescription)
        return NSLocalizedString(@"dreambook.fulfill_dream.invalid_description", nil);
    if (!self.dreamForm.isValidPhoto)
        return NSLocalizedString(@"dreambook.fulfill_dream.invalid_photo", nil);
    return NSLocalizedString(@"error.invalidInput", nil);
}

#pragma mark - validate

- (void)validate
{
    [self.dreamForm validatePhoto];
    [self.dreamForm validateTitle];
    [self.dreamForm validateDescription];
}

- (BOOL)isValidInput
{
    return self.dreamForm.isValidTitle &&
           self.dreamForm.isValidDescription &&
           self.dreamForm.isValidPhoto;
}

@end
