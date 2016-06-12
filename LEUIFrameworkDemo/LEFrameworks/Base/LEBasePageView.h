//
//  LEBasePageView.h
//  ticket
//
//  Created by Larry Emerson on 14-5-9.
//  Copyright (c) 2014年 360CBS. All rights reserved.
//

#import <UIKit/UIKit.h>  
#import "LEBaseViewWithNavigationBar.h"
@interface LEBasePageView : LEBaseViewWithNavigationBar 
//
@property (nonatomic) UIButton*leftButton;  
 
-(id) initWithSuperView:(UIView *)view Title:(NSString *)title LeftButton:(NSString *) back; 

-(void) easeOutViewLogic; 

-(void) eventCallFromChild;

@end
