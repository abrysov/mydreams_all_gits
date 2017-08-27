//
//  UIColor+MyDreams.h
//  MyDreams
//
//  Created by Antol Peshkov on 12.02.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MyDreams)

#pragma mark - selected cell
+ (UIColor *)selectionCellColor;

#pragma mark - view
+ (UIColor *)listDreamsActiveLineButtonColor;
+ (UIColor *)listCompletedDreamsActiveLineButtonColor;
+ (UIColor *)toastViewColor;

#pragma mark - bordered button
+ (UIColor *)borderedButtonStrokeColor;
+ (UIColor *)borderedButtonFillColor;
+ (UIColor *)borderedButtonDreambookColorHighlighted;
+ (UIColor *)borderedButtonDreambookTextColor;
+ (UIColor *)borderedButtonDreambookColorNormal;
+ (UIColor *)borderedButtonActiveColor;
+ (UIColor *)borderedButtonInactiveColor;
+ (UIColor *)borderedButtonGradientBeginColorNormal;
+ (UIColor *)borderedButtonGradientEndColorNormal;
+ (UIColor *)borderedButtonGradientBeginColorHighlighted;
+ (UIColor *)borderedButtonGradientEndColorHighlighted;

#pragma mark - filled button
+ (UIColor *)filledButtonFillColorNormal;
+ (UIColor *)filledButtonFillColorHighlighted;
+ (UIColor *)filledButtonLightFillColorNormal;
+ (UIColor *)filledButtonLightFillColorHighlighted;

#pragma mark - text field
+ (UIColor *)textFieldPlaceholder;
+ (UIColor *)textFieldTextColor;
+ (UIColor *)textFieldPlaceholderTextColor;
+ (UIColor *)textFieldNormalBackgroundColor;
+ (UIColor *)textFieldValidBackgroundColor;
+ (UIColor *)textFieldInvalidBackgroundColor;
+ (UIColor *)textFieldSelectedStateBorderColor;
+ (UIColor *)searchTextFieldNormalBackgroundColor;
+ (UIColor *)textFieldDreambookColor;

#pragma mark - label text
+ (UIColor *)userAgreementColor;

#pragma mark - table view
+ (UIColor *)dreambookTableViewCellSelectionColor;

#pragma mark - registration
+ (UIColor *)invalidStateColor;

#pragma mark - dreambook
+ (UIColor *)dreambookVipColor;
+ (UIColor *)dreambookNormalColor;
+ (UIColor *)dreambookDefaultColor;
+ (UIColor *)dreambookVipHighlightedColor;
+ (UIColor *)dreambookNormalHighlightedColor;

#pragma mark - settings
+ (UIColor *)settingsBaseColor;
+ (UIColor *)settingsTextfieldInvalidStateColor;
+ (UIColor *)settingsTextfieldActiveStateColor;
+ (UIColor *)settingsTextfieldDefaultStateColor;
+ (UIColor *)settingsActiveButtonColor;

#pragma mark - dreams colors
+ (UIColor *)fulfilledDreamColor;

+ (UIColor *)myDreamsDreamColor;
+ (UIColor *)bronzeDreamColor;
+ (UIColor *)silverDreamColor;
+ (UIColor *)goldDreamColor;
+ (UIColor *)platinumDreamColor;
+ (UIColor *)vipDreamColor;
+ (UIColor *)presidentialDreamColor;
+ (UIColor *)imperialDreamColor;

#pragma mark - loading view fadding color
+ (UIColor *)fullScreenLoadingViewBackgroundColor;

#pragma mark - messages
+ (UIColor *)conversationCellDefaultBorderColor;
+ (UIColor *)conversationCellDeleteSwipeButtonColor;
@end
