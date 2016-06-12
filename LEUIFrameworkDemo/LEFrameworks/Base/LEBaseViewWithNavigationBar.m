//
//  LEBaseViewWithNavigationBar.m
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/26.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEBaseViewWithNavigationBar.h"

@implementation LEBaseViewWithNavigationBar{
    NSString *tempTitle;
}
@synthesize viewNavigation=_viewNavigation;
@synthesize viewTitle=_viewTitle;

-(id) initWithSuperView:(UIView *)view Title:(NSString *) title{
    tempTitle=title;
    return [super initWithSuperView:view];
} 
-(void) setIndividualityForInheritedView{
    self.viewStatusBar=[[UIView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideTopCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, StatusBarHeight)]];
    [self.viewStatusBar setBackgroundColor:ColorNavigationBar];
    //
    self.viewNavigation=[[UIImageView alloc] initWithAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomCenter RelativeView:self.viewStatusBar Offset:CGPointZero CGSize:CGSizeMake(self.curFrameWidth, NavigationBarHeight)]];
    [self.viewNavigation setImage:[[UIImage imageNamed:IMG_NavigationBarBG] middleStrechedImage]];
    [self.viewNavigation setUserInteractionEnabled:YES];
    [self.viewNavigation setBackgroundColor:ColorNavigationBar];
    //
    [self.viewContainer setLeAutoLayoutSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorOutsideBottomCenter RelativeView:self.viewNavigation Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth, self.globalVar.ScreenHeight-self.viewStatusBar.bounds.size.height-self.viewNavigation.bounds.size.height)]];
    [self.viewContainer leExecAutoLayout];
    [self.viewContainer setBackgroundColor:ColorViewContainer];
    //
    //
    self.viewTitle=[LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self.viewNavigation Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeMake(self.globalVar.ScreenWidth-NavigationBarHeight*2, NavigationBarHeight)]  LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:tempTitle FontSize:NavigationBarFontSize Font:nil Width:self.globalVar.ScreenWidth-NavigationBarHeight*2 Height:NavigationBarHeight Color:ColorNavigationContent Line:1 Alignment:NSTextAlignmentCenter]];
} 
@end
