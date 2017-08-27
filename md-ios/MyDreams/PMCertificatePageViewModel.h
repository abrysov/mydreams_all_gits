//
//  PMCertificatePageViewModel.h
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@protocol PMCertificatePageViewModel <NSObject>
@property (strong, nonatomic, readonly) RACSignal *imageSignal;
@property (strong, nonatomic, readonly) NSString *dreamerTopInfo;
@property (strong, nonatomic, readonly) NSString *dreamerBottomInfo;
@property (strong, nonatomic, readonly) UIImage *certificateImage;
@property (strong, nonatomic, readonly) NSString *wish;
@property (strong, nonatomic, readonly) NSString *page;
@end