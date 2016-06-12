//
//  LEWebView.h
//  ticket
//
//  Created by Larry Emerson on 14-8-27.
//  Copyright (c) 2014年 360CBS. All rights reserved.
//

#import "LEBasePageView.h"
@protocol LEWebViewDelegate<NSObject>
-(void) onCloseWebView;
@end

@interface LEWebView : LEBasePageView<UIWebViewDelegate>
@property (nonatomic) id<LEWebViewDelegate> delegate;
-(id) initWithSuperView:(UIView *) view  Title:(NSString *) title;
- (void)loadWebPageWithString:(NSString*)urlString;
-(UIWebView *) getWeb;
@end
