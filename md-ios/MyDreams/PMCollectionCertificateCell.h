//
//  PMCollectionCertificateCell.h
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificateViewModel.h"

@interface PMCollectionCertificateCell : UICollectionViewCell
@property (strong, nonatomic) id<PMCertificateViewModel> viewModel;
@end
