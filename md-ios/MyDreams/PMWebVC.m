//
//  PMWebVC.m
//  MyDreams
//
//  Created by Иван Ушаков on 08.04.16.
//  Copyright © 2016 Perpetuum Mobile lab. All rights reserved.
//

#import "PMWebVC.h"
#import <Masonry/Masonry.h>

@interface PMWebVC ()
@end

@implementation PMWebVC

- (void)loadView
{
    [super loadView];
    
    WKWebView *webView = [[WKWebView alloc] initWithFrame:self.view.bounds configuration:[[WKWebViewConfiguration alloc] init]];
    [self.view addSubview:webView];
    self.webView = webView;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(closeButtonHandler:)];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

#pragma mark - actions

- (IBAction)closeButtonHandler:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(closeWebVC:)]) {
        [self.delegate closeWebVC:self];
    }
}

@end
