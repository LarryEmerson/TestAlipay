//
//  LEBaseEmptyView.m
//  spark-client-ios
//
//  Created by Larry Emerson on 15/2/2.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import "LEBaseEmptyView.h"

@implementation LEBaseEmptyView{
}
@synthesize viewContainer=_viewContainer;
@synthesize globalVar=_globalVar;
@synthesize curFrameHight=_curFrameHight;
@synthesize curFrameWidth=_curFrameWidth;

-(id) initWithSuperView:(UIView *)view{ 
    self.superViewContainer=view;
    self.globalVar = [LEUIFramework instance];
    self.curFrameWidth=self.globalVar.ScreenWidth;
    self.curFrameHight=self.globalVar.ScreenHeight;
    self = [super initWithFrame:CGRectMake(0, 0, self.curFrameWidth,self.curFrameHight)];
    [self.superViewContainer addSubview:self];
    [self setBackgroundColor:ColorViewContainer];
    //Container
    self.viewContainer=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:self.bounds.size]];
    [self addSubview:self.viewContainer];
    //
    [self setIndividualityForInheritedView];
    [self setExtraViewInits];
    return self;
}
-(void) setIndividualityForInheritedView{
}
-(void) setExtraViewInits{
}
-(void) easeInView{
    [self setAlpha:0];
    [UIView animateWithDuration:0.2f animations:^(void){
        [self setAlpha:1];
    }];
}
-(void) easeOutView{
    [UIView animateWithDuration:0.2f animations:^(void){
        [self setAlpha:0];
    } completion:^(BOOL isDone){
        [self dismissView];
    }];
}
-(void) dismissView{
    [self removeFromSuperview];
}

@end
