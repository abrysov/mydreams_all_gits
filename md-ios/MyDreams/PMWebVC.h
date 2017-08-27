//
//  PMWebVC.h
//  MyDreams
//
//  Created by Иван Ушаков on 08.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMBaseVC.h"
#import <WebKit/WebKit.h>

@class PMWebVC;

@protocol PMWebVCDelegate <NSObject>
- (void)closeWebVC:(PMWebVC *)webVC;
@end

@interface PMWebVC : PMBaseVC
@property (weak, nonatomic) id<PMWebVCDelegate> delegate;
@property (weak, nonatomic) WKWebView *webView;
@end
