//
//  PMListCertificatesLogic.h
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMPaginationBaseLogic.h"
#import "PMListCertificatesViewModel.h"
#import "PMListNewCertificatesLogic.h"

@protocol PMCertificatesApiClient;
@protocol PMImageDownloader;

extern NSString * const PMListCertificatesLogicErrorDomain;

@interface PMListCertificatesLogic : PMPaginationBaseLogic
@property (nonatomic, strong) id<PMCertificatesApiClient> certificatesApiClient;
@property (strong, nonatomic) id<PMImageDownloader> imageDownloader;
@property (nonatomic, strong, readonly) id<PMListCertificatesViewModel> viewModel;
@property (nonatomic, weak) PMListNewCertificatesLogic *containerLogic;
@property (strong, nonatomic, readonly) RACCommand *backCommand;

- (void)selectCertificateWithIndex:(NSInteger)index;
@end
