//
//  PMCertificateViewModelImpl.m
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMCertificateViewModelImpl.h"

@interface PMCertificateViewModelImpl ()
@property (strong, nonatomic) UIImage *certificateImage;
@end

@implementation PMCertificateViewModelImpl

- (instancetype)initWithCertificateType:(PMDreamCertificateType)certificateType
{
    self = [super init];
    if (self) {
        switch (certificateType) {
            case PMDreamCertificateTypeBronze:
                self.certificateImage = [UIImage imageNamed:@"bronze_mark"];
                break;
            case PMDreamCertificateTypeGold:
                self.certificateImage = [UIImage imageNamed:@"gold_mark"];
                break;
            case PMDreamCertificateTypePlatinum:
                self.certificateImage = [UIImage imageNamed:@"platinum_mark"];
                break;
            case PMDreamCertificateTypeSilver:
                self.certificateImage = [UIImage imageNamed:@"silver_mark"];
                break;
            case PMDreamCertificateTypeVIP:
                self.certificateImage = [UIImage imageNamed:@"vip_mark"];
                break;
            case PMDreamCertificateTypeImperial:
            case PMDreamCertificateTypeMyDreams:
            case PMDreamCertificateTypePresidential:
            case PMDreamCertificateTypeUnknown:
            default:
                self.certificateImage = [UIImage imageNamed:@"vip_mark"];
                break;
        }
    }
    return self;
}

@end
