//
//  PMCertificateViewModel.h
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMCertificateViewModel <NSObject>
@property (strong, nonatomic, readonly) UIImage *certificateImage;
@property (strong, nonatomic, readonly) RACSignal *imageSignal;
@end
