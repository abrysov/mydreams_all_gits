//
//  PMCertificateDetailLogic.h
//  MyDreams
//
//  Created by Alexey Yakunin on 18/07/16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseLogic.h"
#import "PMCertificateDetailViewModel.h"

@protocol PMImageDownloader;

@interface PMCertificateDetailLogic : PMBaseLogic
@property (nonatomic, strong, readonly) id<PMCertificateDetailViewModel> viewModel;
@property (nonatomic, strong) id<PMImageDownloader> imageDownloader;
@end
