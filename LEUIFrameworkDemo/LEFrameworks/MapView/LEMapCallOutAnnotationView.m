//
//  LEMapCallOutAnnotationView.m
//  four23
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LEMapCallOutAnnotationView.h"
#import "LEMapViewAnnotationSubView.h" 
@implementation LEMapCallOutAnnotationView{
    UIImageView *curAnnotationIcon;
    
    CGRect normalFrame;
    NSString *subViewClassName;
    LEMapViewAnnotationSubView *callOutView;
}
- (id)initWithAnnotation:(id <MAAnnotation>)annotation reuseIdentifier:(NSString *) reuseIdentifier CallOutDelegate:(id) delegate SubViewClass:(NSString *) subClass{
    self.callOutDelegate=delegate;
    subViewClassName=subClass;
    return [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
}
-(void) initUI{
    callOutView=[[NSClassFromString(subViewClassName) alloc] performSelector:NSSelectorFromString(@"initWithAnnotation:") withObject:self.annotation];
    [self addSubview:callOutView];
    [callOutView setCallOutDelegate:self.callOutDelegate];
    LEMapCallOutViewAnnotation *anno=(LEMapCallOutViewAnnotation *)self.annotation;
    [callOutView setData:anno.curData];
    [self setFrame:CGRectMake(0, 0, callOutView.bounds.size.width, callOutView.bounds.size.height)];
    UIImage *img=[UIImage imageNamed:anno.curAnnotationIcon]; 
    [self setCenterOffset:CGPointMake(0, -[img size].height -callOutView.bounds.size.height/2 )];
}


@end
