//
//  LEBaseViewWithNavigationBar.h
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/26.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEBaseEmptyView.h"
#define StatusBarHeight 20
@interface LEBaseViewWithNavigationBar : LEBaseEmptyView
@property (nonatomic) UIView *viewStatusBar;
@property (nonatomic) UIImageView *viewNavigation;
@property (nonatomic) UILabel *viewTitle; 
-(id) initWithSuperView:(UIView *)view Title:(NSString *) title; 
@end
