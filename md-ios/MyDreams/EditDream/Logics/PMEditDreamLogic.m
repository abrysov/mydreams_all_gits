//
//  PMEditDreamLogic.m
//  myDreams
//
//  Created by AlbertA on 25/07/2016.
//  Copyright 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMEditDreamLogic.h"
#import "DreambookSegues.h"
#import "PMDreamApiClient.h"
#import "PMDreamForm.h"
#import "DreambookSegues.h"
#import "PMEditDreamViewModelImpl.h"
#import "PMBaseLogic+Protected.h"
#import "PMDreamResponse.h"
#import "PMImageDownloader.h"
#import "PMDetailedDreamContext.h"
#import "PMDreamer.h"

NSString * const PMEditDreamLogicErrorDomain = @"com.mydreams.EditDream.logic.error";

@interface PMEditDreamLogic ()
@property (strong, nonatomic) PMDetailedDreamContext *context;
@property (nonatomic, strong) RACCommand *backCommand;
@property (nonatomic, strong) RACCommand *saveDreamCommand;
@property (nonatomic, strong) PMDreamForm *dreamForm;
@property (nonatomic, strong) PMEditDreamViewModelImpl *viewModel;
@property (nonatomic, strong) RACSubject *progressSubject;

@end

@implementation PMEditDreamLogic
@dynamic context;

- (void)startLogic
{
    self.dreamForm = [[PMDreamForm alloc] initWithDream:self.context.dream];
    [super startLogic];
    
    self.backCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierCloseEditDreamVC];
    self.saveDreamCommand = [self createSaveDreamCommand];
    
    RAC(self, viewModel) = [[RACObserve(self, dreamForm) ignore:nil]
        map:^id(PMDreamForm *form) {
            return [[PMEditDreamViewModelImpl alloc] initWithDreamForm:form];
        }];
    
    @weakify(self);
    self.progressSubject = [RACSubject subject];
    [self.progressSubject subscribeNext:^(NSProgress *progress) {
        @strongify(self);
        PMEditDreamViewModelImpl *viewModel = self.viewModel;
        viewModel.progress = (float)progress.completedUnitCount / progress.totalUnitCount;
    }];
    
    [RACObserve(self, viewModel) subscribeNext:^(PMEditDreamViewModelImpl *viewModel) {
        @strongify(self);
        NSURL *photoUrl = [NSURL URLWithString:self.dreamForm.photoURL.large];
        if (photoUrl) {
            [[self.imageDownloader imageForURL:photoUrl]
                subscribeNext:^(UIImage *photo) {
                    viewModel.photo = photo;
                }];
        }
    }];
}

- (void)setupPhoto:(UIImage *)photo cropRect:(CGRect)cropRect
{
    self.dreamForm.photo = photo;
    self.dreamForm.cropRectX = @(cropRect.origin.x);
    self.dreamForm.cropRectY = @(cropRect.origin.y);
    self.dreamForm.cropRectWidth = @(cropRect.size.width);
    self.dreamForm.cropRectHeight = @(cropRect.size.height);
}

- (void)setupDreamDescription:(NSString *)dreamDescription
{
    self.dreamForm.dreamDescription = dreamDescription;
}

- (void)setupDreamTitle:(NSString *)dreamTitle
{
    self.dreamForm.title = dreamTitle;
}

#pragma mark - private

- (RACCommand *)createSaveDreamCommand
{
    @weakify(self);
    return [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        @strongify(self);
        [self validate];
        if ([self isValidInput]) {
            return [[self.dreamApiClient updateDream:self.dreamForm progress:self.progressSubject]
                doNext:^(PMDreamResponse *response) {
                    @strongify(self);
                    [self.context.dreamSubject sendNext:response.dream];
                    [self performSegueWithIdentifier:kPMSegueIdentifierCloseEditDreamVC];
                }];
        }
    
        NSError *error = [NSError errorWithDomain:PMEditDreamLogicErrorDomain
                                            code:PMEditDreamLogicErrorInvalidInput
                                            userInfo:@{NSLocalizedDescriptionKey:[self errorMessage]}];
        return [RACSignal error:error];
    }];
}

- (NSString *)errorMessage
{
    if (!self.dreamForm.isValidTitle) {
        return NSLocalizedString(@"dreambook.fulfill_dream.invalid_title", nil);
    }
    if (!self.dreamForm.isValidDescription) {
        return NSLocalizedString(@"dreambook.fulfill_dream.invalid_description", nil);
    }
    return NSLocalizedString(@"error.invalidInput", nil);
}

#pragma mark - validate

- (void)validate
{
    [self.dreamForm validateTitle];
    [self.dreamForm validateDescription];
}

- (BOOL)isValidInput
{
    return self.dreamForm.isValidTitle &&
           self.dreamForm.isValidDescription;
}

@end
