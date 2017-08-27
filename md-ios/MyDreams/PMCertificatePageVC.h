//
//  PMCertificatePageVC.h
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificatePageViewModel.h"

@interface PMCertificatePageVC : UIViewController
@property (assign, nonatomic) NSUInteger pageIndex;
@property (strong, nonatomic) id<PMCertificatePageViewModel> viewModel;
@end
