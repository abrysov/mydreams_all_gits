//
//  PMMarksApiClientImpl.h
//  MyDreams
//
//  Created by user on 08.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificatesApiClient.h"

@protocol PMOAuth2APIClient;

@interface PMCertificatesApiClientImpl : NSObject <PMCertificatesApiClient>
@property (strong, nonatomic) id<PMOAuth2APIClient> apiClient;
@end
