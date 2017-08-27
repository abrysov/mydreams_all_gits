//
//  PMMarksApiClient.h
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

@class PMCertificatesForm;
@class PMPage;

@protocol PMCertificatesApiClient <NSObject>
- (RACSignal *)getCertificates:(PMCertificatesForm *)form page:(PMPage *)page;
- (RACSignal *)getCertificatesWithDreamerIdx:(NSNumber *)dreamerIdx form:(PMCertificatesForm *)form page:(PMPage *)page;
@end
