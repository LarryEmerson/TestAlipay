//
//  LEMapCallOutViewAnnotation.m
//  four23
//
//  Created by Larry Emerson on 15/9/6.
//  Copyright (c) 2015年 360cbs. All rights reserved.
//

#import "LEMapCallOutViewAnnotation.h"

@implementation LEMapCallOutViewAnnotation
@synthesize callOutBackground=_callOutBackground;
@synthesize curData = _curData;
-(id) initWithCoordinate:(CLLocationCoordinate2D) coordinate Index:(int) index AnnotationIcon:(NSString *)icon  CallOutBackground:(NSString *) bg  Data:(NSDictionary *) data UserCoordinate:(CLLocationCoordinate2D) userCoordinate{
    self.userCoordinate=userCoordinate;
    self.curData=data;
    self.callOutBackground=bg;
    return [super initWithCoordinate:coordinate Index:index AnnotationIcon:icon];
}

@end