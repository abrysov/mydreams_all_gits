//
//  PMListNewCertificateLogic.h
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMListCertificatesViewModel.h"

@protocol PMCertificatesApiClient;
@protocol PMImageDownloader;

extern NSString * const PMListNewCertificatesLogicErrorDomain;

@interface PMListNewCertificatesLogic : PMPaginationBaseLogic
@property (nonatomic, strong) id<PMCertificatesApiClient> certificatesApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@property (nonatomic, strong, readonly) id<PMListCertificatesViewModel> viewModel;
- (void)setupDreamer:(NSNumber *)dreamerIdx isMe:(BOOL)isMe;
@end

