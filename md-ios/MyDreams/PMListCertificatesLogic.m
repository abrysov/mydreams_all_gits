//
//  PMListCertificatesLogic.m
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListCertificatesLogic.h"
#import "PMCertificatesApiClient.h"
#import "PMImageDownloader.h"
#import "PMCertificatesForm.h"
#import "PMCertificatesResponse.h"
#import "PMPaginationResponseMeta.h"
#import "PMBaseModelIdxWithIsMineContext.h"
#import "PMListCertificatesViewModelImpl.h"
#import "PMCertificateViewModelImpl.h"
#import "PMCertificate.h"
#import "PMBaseLogic+Protected.h"
#import "DreambookSegues.h"
#import "PMCertificateDetailContext.h"

NSString * const PMListCertificatesLogicErrorDomain = @"com.mydreams.ListCertificates.logic.error";

@interface PMListCertificatesLogic ()
@property (strong, nonatomic) RACCommand *backCommand;
@property (nonatomic, strong) PMBaseModelIdxWithIsMineContext *context;
@property (nonatomic, strong) PMCertificatesForm *form;
@property (nonatomic, strong) PMListCertificatesViewModelImpl *viewModel;
@property (nonatomic, strong) NSNumber *dreamerIdx;
@property (nonatomic, assign) BOOL isMe;
@end

@implementation PMListCertificatesLogic
@dynamic context;

- (void)startLogic
{
    self.dreamerIdx = self.context.idx;
    self.isMe = self.context.isMine;
    self.form = [[PMCertificatesForm alloc] init];
    self.viewModel = [[PMListCertificatesViewModelImpl alloc] init];
    
    [super startLogic];
    self.backCommand = [self createRouteCommandWithSegueIdentifier:kPMSegueIdentifierCloseListCertificatesVC];
    
    @weakify(self);
    RAC(self.viewModel, certificates) = [[RACObserve(self, items) ignore:nil]
        map:^id(NSArray *items) {
            @strongify(self);
            return [self certificatesToViewModels:items];
        }];
    
    [[RACObserve(self, containerLogic) ignore:nil] subscribeNext:^(PMListNewCertificatesLogic *containerLogic) {
        @strongify(self);
        [containerLogic setupDreamer:self.dreamerIdx isMe:self.isMe];
    }];
    
}

- (RACSignal *)loadPage:(PMPage *)page
{
    RACSignal *loadCertificates = nil;
    if (self.isMe) {
        loadCertificates = [self.certificatesApiClient getCertificates:self.form page:page];
    }
    else {
        loadCertificates = [self.certificatesApiClient getCertificatesWithDreamerIdx:self.dreamerIdx form:self.form page:page];
    }
    
    return [loadCertificates
        map:^id(PMCertificatesResponse *response) {
            return RACTuplePack(response.certificates, response.meta);
        }];
}

- (RACSignal *)loadData
{
    RACSignal *containerLogicLoadData = (self.containerLogic) ? [self.containerLogic loadData] : [RACSignal return:[NSNull null]];
    return [RACSignal
        combineLatest:@[[super loadData],
                        containerLogicLoadData]];
}

#pragma mark - private

- (NSArray *)certificatesToViewModels:(NSArray *)certificates
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:certificates.count];
    
    for (PMCertificate *certificate in certificates) {
        PMCertificateViewModelImpl *viewModel = [[PMCertificateViewModelImpl alloc] initWithCertificateType:certificate.certificateType];

        NSURL *imageUrl = [NSURL URLWithString:certificate.certifiable.image.large];
        if (imageUrl) {
            viewModel.imageSignal = [self.imageDownloader imageForURL:imageUrl];
        }
        [viewModels addObject:viewModel];
    }
    
    return [NSArray arrayWithArray:viewModels];
}

- (void)selectCertificateWithIndex:(NSInteger)index
{
	PMCertificate *certificate = (PMCertificate *) self.items[index];
	PMCertificateDetailContext *context = [PMCertificateDetailContext contextWithCertificate:certificate];
	[self performSegueWithIdentifier:kPMSegueIdentifierToCertificateDetailVC context:context];
}

@end
