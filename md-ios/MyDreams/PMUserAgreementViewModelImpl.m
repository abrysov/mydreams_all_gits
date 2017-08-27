//
//  PMUserAgreementViewModelImpl.m
//  MyDreams
//
//  Created by user on 14.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMUserAgreementViewModelImpl.h"
#import "UIColor+MyDreams.h"

@interface PMUserAgreementViewModelImpl ()
@property (strong, nonatomic) NSAttributedString *userAgreement;
@end

@implementation PMUserAgreementViewModelImpl

- (instancetype)initWithUserAgreement:(NSString *)userAgreement
{
    self = [super init];
    if (self) {
        userAgreement = [userAgreement stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"];
        self.userAgreement = [[NSAttributedString alloc] initWithData:[userAgreement dataUsingEncoding:NSUTF8StringEncoding]
                                                              options:@{NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType,
                                                                         NSForegroundColorAttributeName:[UIColor userAgreementColor],
                                                                                    NSFontAttributeName:[UIFont fontWithName:@"Helvetica Neue" size:14.0],
                                                                   NSCharacterEncodingDocumentAttribute:@(NSUTF8StringEncoding)}
                                                   documentAttributes:nil
                                                                error:nil];
    }
    return self;
}


@end
