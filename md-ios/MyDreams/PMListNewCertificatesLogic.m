//
//  PMListNewCertificateLogic.m
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMListNewCertificatesLogic.h"
#import "PMListCertificatesViewModelImpl.h"
#import "PMCertificatesForm.h"
#import "PMCertificatePageViewModelImpl.h"
#import "PMCertificate.h"
#import "PMImageDownloader.h"
#import "PMCertificatesApiClient.h"
#import "PMPaginationResponseMeta.h"
#import "PMCertificatesResponse.h"

NSString * const PMListNewCertificatesLogicErrorDomain = @"com.mydreams.ListNewCertificates.logic.error";

@interface PMListNewCertificatesLogic ()
@property (nonatomic, strong) PMCertificatesForm *form;
@property (nonatomic, strong) PMListCertificatesViewModelImpl *viewModel;
@property (nonatomic, strong) NSNumber *dreamerIdx;
@property (nonatomic, assign) BOOL isMe;
@end

@implementation PMListNewCertificatesLogic

- (void)startLogic
{
    self.form = [[PMCertificatesForm alloc] init];
    self.form.isNew = @YES;
    self.form.isGifted = @YES;
    self.viewModel = [[PMListCertificatesViewModelImpl alloc] init];
    [super startLogic];
    
    @weakify(self);
    RAC(self.viewModel, certificates) = [[RACObserve(self, items) ignore:nil]
        map:^id(NSArray *items) {
            @strongify(self);
            return [self certificatesToViewModels:items];
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

- (void)setupDreamer:(NSNumber *)dreamerIdx isMe:(BOOL)isMe
{
    self.dreamerIdx = dreamerIdx;
    self.isMe = isMe;
}

#pragma mark - private

- (NSArray *)certificatesToViewModels:(NSArray *)certificates
{
    NSMutableArray *viewModels = [NSMutableArray arrayWithCapacity:certificates.count];
    
    for (int i = 0; i < certificates.count; i++) {
        PMCertificate *certificate = certificates[i];
        PMCertificatePageViewModelImpl *viewModel = [[PMCertificatePageViewModelImpl alloc] initWithCertificate:certificate totalCount:self.totalCount pageIndex:i];
        NSURL *imageUrl = [NSURL URLWithString:certificate.giftedBy.avatar.large];
        if (imageUrl) {
            viewModel.imageSignal = [self.imageDownloader imageForURL:imageUrl];
        }
        
        [viewModels addObject:viewModel];
    }
    return [NSArray arrayWithArray:viewModels];
}

@end
