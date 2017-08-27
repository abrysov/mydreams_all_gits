//
//  UIColor+MyDreams.m
//  MyDreams
//
//  Created by Antol Peshkov on 12.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "UIColor+MyDreams.h"

@implementation UIColor (MyDreams)

#pragma mark - selected cell

+ (UIColor *)selectionCellColor
{
    return [UIColor colorWithWhite:0.0f alpha:0.05f];
}

#pragma mark - view

+ (UIColor *)listDreamsActiveLineButtonColor
{
    return [UIColor colorWithRed:15.0f/255.0f green:160.0f/255.0f blue:222.0f/255.0f alpha:1.0f];
}

+ (UIColor *)listCompletedDreamsActiveLineButtonColor
{
    return [UIColor colorWithRed:0.0f/255.0f green:193.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
}

+ (UIColor *)toastViewColor
{
    return [UIColor colorWithRed:238.0f/255.0f green:98.0f/255.0f blue:115.0f/255.0f alpha:1.0f];
}

#pragma mark - bordered button

+ (UIColor *)borderedButtonStrokeColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)borderedButtonFillColor
{
    return [UIColor colorWithWhite:1.0f alpha:0.3f];
}

+ (UIColor *)borderedButtonDreambookColorNormal
{
    return [UIColor colorWithRed:186.0f/255.0f green:186.0f/255.0f blue:186.0f/255.0f alpha:1.0f];
}

+ (UIColor *)borderedButtonDreambookTextColor
{
    return [UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1.0f];
}

+ (UIColor *)borderedButtonDreambookColorHighlighted
{
    return [UIColor colorWithWhite:0.0f alpha:0.1];
}

+ (UIColor *)borderedButtonInactiveColor
{
    return [UIColor colorWithRed:74.0f/255.0f green:173.0f/255.0f blue:226.0f/255.0f alpha:0.5f];
}

+ (UIColor *)borderedButtonActiveColor
{
    return [UIColor colorWithRed:74.0f/255.0f green:173.0f/255.0f blue:226.0f/255.0f alpha:1.0f];
}

+ (UIColor *)borderedButtonGradientBeginColorNormal
{
    return [UIColor colorWithRed:42.0f/255.0f green:163.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

+ (UIColor *)borderedButtonGradientEndColorNormal
{
    return [UIColor colorWithRed:180.0f/255.0f green:69.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

+ (UIColor *)borderedButtonGradientBeginColorHighlighted
{
    return [[self borderedButtonGradientBeginColorNormal] colorWithAlphaComponent:0.8f];
}

+ (UIColor *)borderedButtonGradientEndColorHighlighted
{
    return [[self borderedButtonGradientEndColorNormal] colorWithAlphaComponent:0.8f];
}

#pragma mark - filled button

+ (UIColor *)filledButtonFillColorNormal
{
    return [UIColor colorWithWhite:1.0f alpha:0.15f];
}

+ (UIColor *)filledButtonFillColorHighlighted
{
    return [UIColor colorWithWhite:1.0f alpha:0.3f];
}

+ (UIColor *)filledButtonLightFillColorNormal
{
    return [UIColor colorWithWhite:1.0f alpha:0.3f];
}

+ (UIColor *)filledButtonLightFillColorHighlighted
{
    return [UIColor colorWithWhite:1.0f alpha:0.45f];
}

#pragma mark - text field

+ (UIColor *)textFieldPlaceholder
{
    return [UIColor colorWithWhite:0.0f alpha:0.4];
}

+ (UIColor *)textFieldTextColor
{
    return [UIColor whiteColor];
}

+ (UIColor *)textFieldPlaceholderTextColor
{
    return [UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1.0f];
}

+ (UIColor *)textFieldNormalBackgroundColor
{
    return [UIColor colorWithWhite:0.0f alpha:0.3f];
}

+ (UIColor *)searchTextFieldNormalBackgroundColor
{
    return [UIColor colorWithWhite:0.0f alpha:0.05f];
}

+ (UIColor *)textFieldValidBackgroundColor
{
    return [UIColor colorWithRed:67.0f/255.0 green:139.0f/255.0f blue:175.0f/255.0f alpha:1.0f];
}

+ (UIColor *)textFieldInvalidBackgroundColor
{
    return [UIColor colorWithRed:255.0f/255.0 green:118.0f/255.0f blue:0.0f/255.0f alpha:0.3f];
}

+ (UIColor *)textFieldSelectedStateBorderColor
{
    return [UIColor colorWithRed:167.0f/255.0f green:153.0f/255.0f blue:214.0f/255.0f alpha:1.0f];
}

+ (UIColor *)textFieldDreambookColor
{
    return [UIColor colorWithRed:131.0f/255.0f green:144.0f/255.0f blue:152.0f/255.0f alpha:1.0f];
}

#pragma mark - label text

+ (UIColor *)userAgreementColor
{
    return [UIColor colorWithRed:74.0f/255.0f green:74.0f/255.0f blue:74.0f/255.0f alpha:1.0f];
}

#pragma mark - table view

+ (UIColor *)dreambookTableViewCellSelectionColor
{
    return [UIColor colorWithRed:74.0f/255.0f green:173.0f/255.0f blue:226.0/255.0f alpha:0.1f];
}

#pragma mark - registration

+ (UIColor *)invalidStateColor
{
    return [UIColor colorWithRed:240.0f/255.0 green:100.0f/255.0f blue:117.0f/255.0f alpha:1.0f];
}

#pragma mark - dreambook

+ (UIColor *)dreambookVipColor
{
    return [UIColor colorWithRed:150.0f/255.0f green:82.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
}

+ (UIColor *)dreambookVipHighlightedColor
{
    return [UIColor colorWithRed:120.0f/255.0f green:61.0f/255.0f blue:211.0f/255.0f alpha:1.0f];
}

+ (UIColor *)dreambookNormalColor
{
    return [UIColor colorWithRed:15.0f/255.0f green:160.0f/255.0f blue:222.0f/255.0f alpha:1.0f];
}

+ (UIColor *)dreambookNormalHighlightedColor
{
    return [UIColor colorWithRed:4.0f/255.0f green:128.0f/255.0f blue:182.0f/255.0f alpha:1.0f];
}

+ (UIColor *)dreambookDefaultColor
{
    return [UIColor colorWithRed:186.0f/255.0f green:186.0f/255.0f blue:186.0f/255.0f alpha:1.0f];
}

#pragma mark - settings

+ (UIColor *)settingsBaseColor
{
    return [UIColor colorWithRed:131.0f/255.0f green:144.0f/255.0f blue:152.0f/255.0f alpha:1.0f];
}

+ (UIColor *)settingsTextfieldInvalidStateColor
{
    return [UIColor colorWithRed:208.0f/255.0 green:2.0f/255.0f blue:27.0f/255.0f alpha:1.0f];
}

+ (UIColor *)settingsTextfieldActiveStateColor
{
    return [UIColor colorWithRed:15.0f/255.0 green:160.0f/255.0f blue:222.0f/255.0f alpha:1.0f];
}

+ (UIColor *)settingsTextfieldDefaultStateColor
{
    return [UIColor colorWithRed:229.0f/255.0 green:235.0f/255.0f blue:240.0f/255.0f alpha:1.0f];
}

+ (UIColor *)settingsActiveButtonColor
{
    return [UIColor colorWithRed:15.0f/255.0 green:156.0f/255.0f blue:216.0f/255.0f alpha:1.0f];
}

#pragma mark - dreams colors

+ (UIColor *)fulfilledDreamColor
{
    return [UIColor colorWithRed:0.0f/255.0 green:193.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
}

+ (UIColor *)myDreamsDreamColor
{
    return [UIColor colorWithRed:0.0f/255.0 green:193.0f/255.0f blue:140.0f/255.0f alpha:1.0f];
}

+ (UIColor *)bronzeDreamColor
{
    return [UIColor colorWithRed:190.0f/255.0 green:132.0f/255.0f blue:119.0f/255.0f alpha:1.0f];
}

+ (UIColor *)silverDreamColor
{
    return [UIColor colorWithRed:173.0f/255.0 green:173.0f/255.0f blue:173.0f/255.0f alpha:1.0f];
}

+ (UIColor *)goldDreamColor
{
    return [UIColor colorWithRed:235.0f/255.0 green:166.0f/255.0f blue:33.0f/255.0f alpha:1.0f];
}

+ (UIColor *)platinumDreamColor
{
    return [UIColor colorWithRed:95.0f/255.0 green:135.0f/255.0f blue:159.0f/255.0f alpha:1.0f];
}

+ (UIColor *)vipDreamColor
{
    return [UIColor colorWithRed:147.0f/255.0 green:92.0f/255.0f blue:224.0f/255.0f alpha:1.0f];
}

+ (UIColor *)presidentialDreamColor
{
    return [UIColor colorWithRed:27.0f/255.0 green:144.0f/255.0f blue:234.0f/255.0f alpha:1.0f];
}

+ (UIColor *)imperialDreamColor
{
    return [UIColor colorWithRed:0.0f/255.0 green:56.0f/255.0f blue:116.0f/255.0f alpha:1.0f];
}

#pragma mark - loading view fadding color
+ (UIColor *)fullScreenLoadingViewBackgroundColor
{
	return [UIColor colorWithRed:41.0f/255.0 green:51.0f/255.0f blue:64.0f/255.0f alpha:0.5f];
}

#pragma mark - messages

+ (UIColor *)conversationCellDefaultBorderColor
{
	return [UIColor colorWithRed:234.0f/255.0 green:239.0f/255.0f blue:243.0f/255.0f alpha:0.5f];
}

+ (UIColor *)conversationCellDeleteSwipeButtonColor
{
	return [UIColor colorWithRed:15.0f/255.0f green:160.0f/255.0f blue:222.0f/255.0f alpha:1.0f];
}
@end
