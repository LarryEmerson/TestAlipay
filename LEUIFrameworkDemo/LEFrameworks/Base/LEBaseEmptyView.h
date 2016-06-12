//
//  LEBaseEmptyView.h
//  spark-client-ios
//
//  Created by Larry Emerson on 15/2/2.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LEUIFrameworkImporter.h"

@interface LEBaseEmptyView : UIView

@property (nonatomic) UIView *superViewContainer;
@property (nonatomic) UIView *viewContainer;

@property (nonatomic) LEUIFramework *globalVar;
@property (nonatomic) int curFrameWidth;
@property (nonatomic) int curFrameHight;
 
-(id) initWithSuperView:(UIView *)view;
-(void) setIndividualityForInheritedView;
-(void) setExtraViewInits;

-(void) easeInView;
-(void) easeOutView;
-(void) dismissView;
@end
