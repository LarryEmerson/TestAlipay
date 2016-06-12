//
//  LEBaseTableViewSection.m
//  spark-client-ios
//
//  Created by Larry Emerson on 15/2/5.
//  Copyright (c) 2015年 Syan. All rights reserved.
//

#import "LEBaseTableViewSection.h" 
@implementation LEBaseTableViewSection

-(id) initWithSectionText:(NSString *) text{
    self=[super initWithFrame:CGRectMake(0, 0, [LEUIFramework instance].ScreenWidth, DefaultSectionHeight)];
    [self setBackgroundColor:ColorTableViewGray];
    [LEUIFramework getUIImageViewWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self EdgeInsects:UIEdgeInsetsMake(DefaultSectionHeight-1, 0, 0, 0)] Image:[ColorMask imageWithSize:CGSizeMake(1, 1)]];
    [LEUIFramework getUILabelWithSettings:[[LEAutoLayoutSettings alloc] initWithSuperView:self Anchor:LEAnchorInsideCenter Offset:CGPointZero CGSize:CGSizeZero] LabelSettings:[[LEAutoLayoutLabelSettings alloc] initWithText:text FontSize:10 Font:nil Width:0 Height:0 Color:ColorGrayText Line:1 Alignment:NSTextAlignmentCenter]]; 
    return self;
}

@end
