//
//  PMCertificateType.h
//  MyDreams
//
//  Created by user on 11.07.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

typedef NS_ENUM(NSUInteger, PMDreamCertificateType) {
    PMDreamCertificateTypeUnknown,
    PMDreamCertificateTypeMyDreams,
    PMDreamCertificateTypeBronze,
    PMDreamCertificateTypeSilver,
    PMDreamCertificateTypeGold,
    PMDreamCertificateTypePlatinum,
    PMDreamCertificateTypeVIP,
    PMDreamCertificateTypePresidential,
    PMDreamCertificateTypeImperial,
};

@interface PMCertificateType : NSObject
+ (NSValueTransformer *)certificateTypeValueTransformer;
@end
    