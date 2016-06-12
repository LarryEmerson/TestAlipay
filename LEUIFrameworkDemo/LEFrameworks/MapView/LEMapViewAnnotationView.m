//
//  LEMapViewAnnotationView.m
//  LEFrameworks
//
//  Created by Larry Emerson on 15/8/27.
//  Copyright (c) 2015年 LarryEmerson. All rights reserved.
//

#import "LEMapViewAnnotationView.h"
@implementation LEMapViewAnnotationView{
    UIImageView *curAnnotationIcon;
}
-(void) initUI { 
    LEMapViewAnnotation *anno=(LEMapViewAnnotation *)self.annotation;
    curAnnotationIcon=[[UIImageView alloc]initWithImage:[UIImage imageNamed:anno.curAnnotationIcon]];
    [self addSubview:curAnnotationIcon];
    [self setFrame:CGRectMake(0, 0, curAnnotationIcon.bounds.size.width, curAnnotationIcon.bounds.size.height)];
    [self setCenterOffset:CGPointMake(0, -curAnnotationIcon.bounds.size.height/2)]; 
}
@end
